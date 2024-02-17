//
//  Enums.swift
//  Halcyon 2.0 Watch App
//
//  Created by Michel Lapointe on 2024-02-13.
//

import Foundation

enum entityType {
    case room(Room)
}

enum Room: String, CaseIterable {
    case Chambre = "Chambre"
    case TVRoom = "TV Room"
    case Cuisine = "Cuisine"
    case Salon = "Salon"
    case Amis = "Amis"
    
    var entityId: String {
         "climate.\(self.rawValue)_thermostat"
     }
}

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

public enum ParameterValue: Encodable {
    case string(String)
    case integer(Int)
    case double(Double) // Add this line if it's missing

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let stringValue):
            try container.encode(stringValue)
        case .integer(let intValue):
            try container.encode(intValue)
        case .double(let doubleValue): // Handle encoding for the double case
            try container.encode(doubleValue)
        }
    }
}
