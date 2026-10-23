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

    static let pinnedHost = "www.lge-india.com"


    static let allowedSPKIHashes: [String] = [
        "kuYFtyf9l4emvim6bqsTojCDxcRv1a66K0PJ+qd1j/0=", // leaf key — www.lge-india.com
        "SDG5orEv8iX6MNenIAxa8nQFNpROB/6+llsZdXHZNqs=",
        "i7WTqTvh0OioIruIfFR4kMPnBqrS2rdiVPl/s2uC/CY="// intermediate CA key — EM DV TLS CA - G2A-1
    ]

    /// Request timeout in seconds. Matches the previous implementation so
    /// behaviour is unchanged.
    static let requestTimeout: TimeInterval = 30

    /// UserDefaults key the rest of the app already writes the session token to.
    static let tokenUserDefaultsKey = "TokenNo"

    /// Request-body parameter key the token is injected under.
    static let tokenParameterKey = "TokenNo"
}
