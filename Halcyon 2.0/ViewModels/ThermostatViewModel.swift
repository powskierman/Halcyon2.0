//
//  ThermostatViewModel.swift
//  Halcyon 2.0 Watch App
//
//  Created by Michel Lapointe on 2024-02-13.
//

import SwiftUI
import Combine
import HassWatchFramework

class ThermostatViewModel: ObservableObject {
    @Published var tempSet: Int = 22
    @Published var fanSpeed: String = "auto"
    @Published var halcyonOff: Bool = true
    @Published var halcyonMode: String = "cool"
    @Published var errorMessage: String?


    private var restClient: HassRestClient?

    init() {
        print("[ThermostatViewModel] Initializing...")
        self.restClient = HassRestClient()
        print("[ThermostatViewModel] HassRestClient initialized.")

        if restClient == nil {
            print("[ThermostatViewModel] Failed to initialize HassRestClient.")
            self.errorMessage = "Failed to initialize HassRestClient"
        }
    }

    func sendCommand(entityId: String, newState: String) {
        guard let restClient = restClient else {
            print("[WatchViewModel] RestClient is nil.")
            return
        }

        restClient.changeState(entityId: entityId, newState: newState) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entity):
                    print("[WatchViewModel] Command sent successfully to \(entityId): \(entity.state)")
                    // Update UI based on the response
                    // ... (handle the update here)
                case .failure(let error):
                    print("[WatchViewModel] Error sending command to \(entityId): \(error)")
                    self.errorMessage = "Failed to send command to \(entityId)"
                }
            }
        }
    }
}

