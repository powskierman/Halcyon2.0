//
//  WatchManager.swift
//  GarageWatchHass Watch App
//
//  Created by Michel Lapointe on 2024-02-13.
//

import SwiftUI
import Combine
import HassWatchFramework

class WatchManager: ObservableObject {
    @Published var tempSet: Int = 22
    @Published var fanSpeed: String = "auto"
    @Published var halcyonOff: Bool = true
    @Published var halcyonMode: String = "cool"
    @Published var errorMessage: String?
    @Published var lastCallStatus: CallStatus = .pending
    @Published var hasErrorOccurred: Bool = false

    private var restClient: HassRestClient?
    private var cancellables = Set<AnyCancellable>()
    private var initializationFailed = false
    
    static let shared = WatchManager()

    init() {
        print("[WatchManager] Initialized.")
    }

    func sendCommand(entityId: String, newState: String) {
        HassClientService.shared.sendCommand(entityId: entityId, newState: newState) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entity):
                    print("[WatchManager] Command sent successfully to \(entityId): \(entity.state)")
                case .failure(let error):
                    print("[WatchManager] Error sending command to \(entityId): \(error)")
                    self?.errorMessage = "Failed to send command to \(entityId)"
                }
            }
        }
    }

    func handleScriptAction(entityId: String) {
        HassClientService.shared.callScript(entityId: entityId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("[WatchManager] Script executed successfully")
                    self?.lastCallStatus = .success
                case .failure(let error):
                    print("[WatchManager] Error executing script \(entityId): \(error)")
                    self?.lastCallStatus = .failure
                    self?.errorMessage = "Failed to execute script \(entityId)"
                }
            }
        }
    }
}
