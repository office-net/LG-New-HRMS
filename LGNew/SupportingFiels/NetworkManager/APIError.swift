//
//  APIError.swift
//  Typed error model. Replaces the old `NSError(domain: "Pinning Failed", code: 999)`
//  "magic error" with real, exhaustive, LocalizedError-conforming enums so callers
//  (and crash-report tooling) can pattern-match on exact failure reasons instead of
//  string-comparing a domain name.
//

import Foundation

/// Failures specific to SSL / SPKI pin validation. Kept separate from
/// `NetworkError` (Interface Segregation) so security-relevant failures are
/// never accidentally confused with ordinary connectivity failures — this
/// distinction matters a lot for a banking app's audit logs.
enum SSLPinningError: Error, LocalizedError {

    /// The trust object contained no certificates at all — should never
    /// happen in practice, but fail closed rather than silently pass.
    case noCertificatesFound

    /// Apple's Security framework could not hand back a usable `SecKey` or
    /// raw key representation for a certificate in the chain.
    case publicKeyExtractionFailed

    /// The certificate's public key uses an algorithm/size we do not have
    /// an ASN.1 SPKI header for. Fails closed rather than guessing.
    case unsupportedKeyAlgorithm

    /// Apple's default trust validation passed, but none of the
    /// certificates in the chain matched any pinned SPKI hash. This is the
    /// "someone is intercepting your TLS connection" case.
    case pinMismatch

    var errorDescription: String? {
        switch self {
        case .noCertificatesFound:
            return "No certificates were found in the server trust chain."
        case .publicKeyExtractionFailed:
            return "Unable to extract a public key from the server certificate."
        case .unsupportedKeyAlgorithm:
            return "The server certificate uses a public key algorithm/size that is not supported for pinning."
        case .pinMismatch:
            return "The server's public key does not match any pinned key. The connection was blocked for your security."
        }
    }
}

/// General networking-layer errors for the app. Nothing here throws an
/// `NSError` with a made-up domain/code anymore — every failure is a named,
/// documented case.
enum NetworkError: Error, LocalizedError {
    case invalidURL(String)
    case noInternetConnection
    case requestFailed(underlying: Error)
    case sslPinningFailed(SSLPinningError)
    case noData
    case decodingFailed(underlying: Error)
    case serverError(statusCode: Int)
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "The requested URL is invalid: \(url)"
        case .noInternetConnection:
            return "No internet connection is available."
        case .requestFailed(let underlying):
            return "The request failed: \(underlying.localizedDescription)"
        case .sslPinningFailed(let sslError):
            return sslError.errorDescription
        case .noData:
            return "No data was received from the server."
        case .decodingFailed(let underlying):
            return "Failed to decode the server response: \(underlying.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned an error status code: \(statusCode)."
        case .unknown(let underlying):
            return "An unknown error occurred: \(underlying.localizedDescription)"
        }
    }

    /// Convenience mapper from a raw `Error` (e.g. an `AFError` bubbled up
    /// from Alamofire) into our typed `NetworkError`, unwrapping an
    /// `SSLPinningError` if that's what actually caused the failure.
    static func from(_ error: Error) -> NetworkError {
        if let sslError = error as? SSLPinningError {
            return .sslPinningFailed(sslError)
        }
        if let underlyingSSLError = (error as NSError).underlyingErrors
            .compactMap({ $0 as? SSLPinningError }).first {
            return .sslPinningFailed(underlyingSSLError)
        }
        return .requestFailed(underlying: error)
    }
}
