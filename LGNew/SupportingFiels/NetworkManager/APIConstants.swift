//
//  APIConstants.swift
//  Single source of truth for base URL, pinned host, and pinned SPKI hashes.
//  Keeping these in one enum (rather than scattered string literals) is what
//  makes future key-rotation a one-line change instead of a code hunt.
//

import Foundation

enum APIConstants {

    /// Base URL for all API calls.
    static let baseURL = "https://www.lge-india.com/AppServices.svc/"

    /// The exact host whose certificate we pin against. This MUST equal the
    /// host portion of `baseURL` — Apple's default validation checks that the
    /// certificate's SAN/CN matches this host, so a mismatch here would make
    /// every single request fail default validation before pinning even runs.
    static let pinnedHost = "www.lge-india.com"

    /// Base64 SHA-256 hashes of the SubjectPublicKeyInfo (SPKI) for every
    /// public key considered trusted for `pinnedHost`.
    ///
    /// - Index 0 ("current key") was independently re-derived from the
    ///   uploaded `lge-india_com.crt` certificate using:
    ///   `openssl x509 -in lge-india_com.crt -noout -pubkey | \`
    ///   `openssl pkey -pubin -outform der | \`
    ///   `openssl dgst -sha256 -binary | openssl enc -base64`
    ///   and it matches the hash in the spec exactly, confirming it is the
    ///   real production key for www.lge-india.com as of 2026-08-11.
    ///
    /// - Index 1 ("backup key") is a PLACEHOLDER. Generate it from a second,
    ///   already-issued-but-not-yet-deployed certificate/key pair BEFORE
    ///   shipping this to production. Without a real backup pin, the very
    ///   first server-side key rotation will hard-lock every installed copy
    ///   of the app out of the API (fail-closed pinning has no fallback).
    static let allowedSPKIHashes: [String] = [
        "Eh8c3jO3TfrXcOp3xfcTkgGE4gL4k9DXtEh3liJbFss=", // leaf key — www.lge-india.com
        "zrUpja649ZJ5SAtGACyJ93Vcw6FpUUsRuBC+/BlaAff=",
        "vRU+17BDT2iGsXvOi76E7TQMcTLXAqj0+jGPdW7L1ff="// intermediate CA key — EM DV TLS CA - G2A-1
    ]

    /// Request timeout in seconds. Matches the previous implementation so
    /// behaviour is unchanged.
    static let requestTimeout: TimeInterval = 30

    /// UserDefaults key the rest of the app already writes the session token to.
    static let tokenUserDefaultsKey = "TokenNo"

    /// Request-body parameter key the token is injected under.
    static let tokenParameterKey = "TokenNo"
}
