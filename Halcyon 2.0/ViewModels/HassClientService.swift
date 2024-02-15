//
//  HassClientService.swift
//  Halcyon 2.0 Watch App
//
//  Created by Michel Lapointe on 2024-02-15.
//

import Foundation
import HassWatchFramework

class HassClientService {
    static let shared = HassClientService()
    private var restClient: HassRestClient

    init() {
        self.restClient = HassRestClient()
    }

    func sendCommand(entityId: String, newState: String, completion: @escaping (Result<HAEntity, Error>) -> Void) {
        restClient.changeState(entityId: entityId, newState: newState, completion: completion)
    }

    // Additional functionalities leveraging HassRestClient
    func fetchDeviceState(deviceId: String, completion: @escaping (Result<HassRestClient.DeviceState, Error>) -> Void) {
        restClient.fetchDeviceState(deviceId: deviceId, completion: completion)
    }

    func callScript(entityId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        restClient.callScript(entityId: entityId, completion: completion)
    }
}
