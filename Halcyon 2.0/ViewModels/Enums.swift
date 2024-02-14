//
//  Enums.swift
//  Halcyon 2.0 Watch App
//
//  Created by Michel Lapointe on 2024-02-13.
//

import Foundation

enum halcyonMode {
    case auto
    case heat
    case cool
    case dry
    case fanOnly
}

enum fanSpeed {
    case auto
    case low
    case medium
    case high
    case quiet
}

// Enum to represent the status of a REST API call
enum CallStatus {
    case success
    case failure
    case pending
}
