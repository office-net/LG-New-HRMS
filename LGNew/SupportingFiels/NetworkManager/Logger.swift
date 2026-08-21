//
//  Logger.swift
//  Centralised logging. Every call site is wrapped in `#if DEBUG`, so ALL
//  of it — URLs, headers, request bodies, tokens, SSL pin match/mismatch
//  details — is completely compiled OUT of Release builds. This matters a
//  lot for a banking app: none of this can leak into device console logs,
//  crash reporters, or be read off a jailbroken device in production.
//

import Foundation

enum LogLevel: String {
    case info = "ℹ️"
    case success = "✅"
    case warning = "⚠️"
    case error = "❌"
}

enum Logger {

    /// General API lifecycle logs (URL, parameters, response, failures).
    static func api(_ message: String, level: LogLevel = .info) {
        #if DEBUG
        print("\(level.rawValue) [API] \(message)")
        #endif
    }

    /// SSL / SPKI pinning specific logs (trust evaluation, matched key, pin failure).
    static func ssl(_ message: String, level: LogLevel = .info) {
        #if DEBUG
        print("\(level.rawValue) [SSL Pinning] \(message)")
        #endif
    }

    /// Low-level transport / session logs.
    static func network(_ message: String, level: LogLevel = .info) {
        #if DEBUG
        print("\(level.rawValue) [Network] \(message)")
        #endif
    }
}
