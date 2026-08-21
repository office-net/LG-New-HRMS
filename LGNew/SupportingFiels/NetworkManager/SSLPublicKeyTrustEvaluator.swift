//
//  SSLPublicKeyTrustEvaluator.swift
//  Production-grade SPKI (Subject Public Key Info) pinning for Alamofire 5.8
//
//  WHY SPKI PINNING AND NOT CERTIFICATE PINNING:
//  Certificate pinning hashes the WHOLE certificate (SecCertificateCopyData).
//  That hash changes every single time the certificate is renewed, even if the
//  bank/vendor re-uses the exact same key pair — because serial number, validity
//  dates and the CA signature all change. That forces an app-store release every
//  renewal cycle, which is operationally dangerous for a banking app (a missed
//  release = total app outage the day the cert expires).
//
//  SPKI pinning hashes ONLY the public key structure inside the certificate.
//  As long as the server keeps using the same key pair (or we've pre-pinned a
//  backup key for the *next* key pair), certificate renewal is completely
//  transparent to the app. This is also the exact mechanism used by HPKP,
//  TrustKit, and OWASP MASVS-NETWORK's recommended pinning approach.
//

import Foundation
import Security
import CryptoKit
import Alamofire

// MARK: - ASN.1 SubjectPublicKeyInfo header reconstruction
//
// `SecKeyCopyExternalRepresentation` only returns the "bare" key material
// (e.g. for RSA: just the modulus + exponent, PKCS#1 style). It deliberately
// does NOT return the full DER-encoded SubjectPublicKeyInfo (SPKI) structure
// defined in RFC 5280 (AlgorithmIdentifier + BIT STRING wrapper).
//
// To produce a hash that is byte-for-byte identical to what OpenSSL/other
// platforms compute (and identical to the SPKI hash the security team
// generates from the .crt file for the allow-list), we must manually
// prepend the correct, algorithm-specific ASN.1 header before hashing.
// These headers are fixed, well-known byte sequences (not secrets) for a
// given key algorithm + key size.
enum ASN1SPKIHeader {

    /// RSA 2048-bit — matches the current www.lge-india.com production key.
    static let rsa2048: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86,
        0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0F, 0x00
    ]

    /// RSA 3072-bit.
    static let rsa3072: [UInt8] = [
        0x30, 0x82, 0x01, 0xA2, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86,
        0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x8F, 0x00
    ]

    /// RSA 4096-bit — kept in case the backup/rotated key uses a larger key size.
    static let rsa4096: [UInt8] = [
        0x30, 0x82, 0x02, 0x22, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86,
        0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x02, 0x0F, 0x00
    ]

    /// EC P-256 (prime256v1 / secp256r1).
    static let ecdsaP256: [UInt8] = [
        0x30, 0x59, 0x30, 0x13, 0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02,
        0x01, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07, 0x03,
        0x42, 0x00
    ]

    /// EC P-384 (secp384r1).
    static let ecdsaP384: [UInt8] = [
        0x30, 0x76, 0x30, 0x10, 0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02,
        0x01, 0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x22, 0x03, 0x62, 0x00
    ]

    /// Returns the correct header for the key type/size Apple reports for a
    /// given `SecKey`'s attributes dictionary, or `nil` if the algorithm/size
    /// combination is not one we explicitly support (fail closed, never guess).
    static func header(for attributes: [String: Any]) -> [UInt8]? {
        guard
            let keyType = attributes[kSecAttrKeyType as String] as? String,
            let keySizeInBits = attributes[kSecAttrKeySizeInBits as String] as? Int
        else { return nil }

        switch (keyType, keySizeInBits) {
        case (String(kSecAttrKeyTypeRSA), 2048):
            return rsa2048
        case (String(kSecAttrKeyTypeRSA), 3072):
            return rsa3072
        case (String(kSecAttrKeyTypeRSA), 4096):
            return rsa4096
        case (String(kSecAttrKeyTypeECSECPrimeRandom), 256):
            return ecdsaP256
        case (String(kSecAttrKeyTypeECSECPrimeRandom), 384):
            return ecdsaP384
        default:
            return nil
        }
    }
}

// MARK: - Trust Evaluator

/// Reusable, dependency-injectable SPKI pinning evaluator.
/// Conforms to Alamofire's `ServerTrustEvaluating`, so it plugs directly into
/// `ServerTrustManager` without any custom `URLSessionDelegate` code.
///
/// Single Responsibility: this type does exactly one thing — decide whether a
/// `SecTrust` for a given host is acceptable. It knows nothing about
/// networking, tokens, or JSON, so it can be unit tested in isolation and
/// reused by any future `Session` the app creates.
final class SSLPublicKeyTrustEvaluator: ServerTrustEvaluating {

    private let pinnedHashes: Set<String>
    private let performDefaultValidation: Bool

    /// - Parameters:
    ///   - pinnedHashes: Base64-encoded SHA-256 SPKI hashes that are acceptable
    ///     for this host. Supports multiple entries so a "current" and
    ///     "backup/next" key can both be trusted at once (safe rotation).
    ///   - performDefaultValidation: When `true` (default, and strongly
    ///     recommended), Apple's own trust evaluation — chain validity,
    ///     expiration, trusted root, hostname match — runs BEFORE our SPKI
    ///     check. Pinning only ever narrows trust further; it must never be
    ///     the only check, or a technically-invalid chain with a "correct"
    ///     key could still be accepted.
    init(pinnedHashes: [String], performDefaultValidation: Bool = true) {
        self.pinnedHashes = Set(pinnedHashes)
        self.performDefaultValidation = performDefaultValidation
    }

    func evaluate(_ trust: SecTrust, forHost host: String) throws {
        Logger.ssl("Evaluating host: \(host)")

        // STEP 1 — Apple Trust Validation (REQUIRED FIRST).
        // Confirms: chain chains up to a trusted root, no certificate in the
        // chain is expired/not-yet-valid, and the leaf's SAN/CN matches `host`.
        // If this fails, the connection is rejected immediately — pinning
        // never gets a chance to "override" a broken chain.
        if performDefaultValidation {
            do {
                try trust.af.performDefaultValidation(forHost: host)
            } catch {
                Logger.ssl("Apple default trust validation FAILED: \(error.localizedDescription)", level: .error)
                throw error
            }
        }
        Logger.ssl("Apple default trust validation passed")

        // STEP 2 — Walk every certificate in the now-validated chain (leaf +
        // intermediates). Checking the whole chain — not just index 0 — is
        // what makes certificate ROTATION safe: while the server is mid-swap
        // between an old and new leaf certificate, at least one certificate's
        // key will still match one of our pins.
        guard
            let certificateChain = SecTrustCopyCertificateChain(trust) as? [SecCertificate],
            !certificateChain.isEmpty
        else {
            Logger.ssl("No certificates found in trust chain", level: .error)
            throw SSLPinningError.noCertificatesFound
        }

        var matchedHash: String?

        for certificate in certificateChain {
            guard let spkiHash = try? Self.spkiSHA256Hash(for: certificate) else { continue }
            Logger.ssl("Candidate SPKI hash in chain: \(spkiHash)")

            if pinnedHashes.contains(spkiHash) {
                matchedHash = spkiHash
                break
            }
        }

        guard let matched = matchedHash else {
            Logger.ssl("Pin validation FAILED — no certificate in the chain matched any allowed SPKI hash. Possible MITM attack. Blocking request.", level: .error)
            throw SSLPinningError.pinMismatch
        }

        Logger.ssl("Pin validation SUCCEEDED. Matched key: \(matched)", level: .success)
    }

    /// Computes the Base64 SHA-256 digest of a certificate's full
    /// SubjectPublicKeyInfo (algorithm header + raw key bytes).
    ///
    /// Deliberately does NOT use `SecCertificateCopyData` (that hashes the
    /// whole certificate — forbidden by design, see file header comment).
    static func spkiSHA256Hash(for certificate: SecCertificate) throws -> String {
        guard let publicKey = SecCertificateCopyKey(certificate) else {
            throw SSLPinningError.publicKeyExtractionFailed
        }

        guard let keyAttributes = SecKeyCopyAttributes(publicKey) as? [String: Any] else {
            throw SSLPinningError.publicKeyExtractionFailed
        }

        guard let asn1Header = ASN1SPKIHeader.header(for: keyAttributes) else {
            throw SSLPinningError.unsupportedKeyAlgorithm
        }

        var copyError: Unmanaged<CFError>?
        guard let rawKeyData = SecKeyCopyExternalRepresentation(publicKey, &copyError) as Data? else {
            throw SSLPinningError.publicKeyExtractionFailed
        }

        var spkiData = Data(asn1Header)
        spkiData.append(rawKeyData)

        let digest = SHA256.hash(data: spkiData)
        return Data(digest).base64EncodedString()
    }
}
