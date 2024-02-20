////
////  WatchManager.swift
////  GarageWatchHass Watch App
////
////  Created by Michel Lapointe on 2024-02-13.
////
//
//import SwiftUI
//import Combine
//import HassWatchFramework
//
//class WatchManager: ObservableObject {
//    @Published var tempSet: Int = 22
//    @Published var fanSpeed: String = "auto"
//    @Published var halcyonOff: Bool = true
//    @Published var halcyonMode: HvacModes = .cool // Default to .cool, but set based on condition
//    @Published var errorMessage: String?
//    @Published var lastCallStatus: CallStatus = .pending
//    @Published var hasErrorOccurred: Bool = false
//
//    private var restClient: HassRestClient?
//    private var cancellables = Set<AnyCancellable>()
//    private var initializationFailed = false
//    
//    static let shared = WatchManager()
//
//    init() {
//        print("[WatchManager] Initialized.")
//    }
//
//    func sendCommand(entityId: String, newState: String, temperature: Int? = nil, hvacMode: HvacModes? = nil) {
//        // Prepare the data for the command.
//        var commandData: [String: HassRestClient.AnyEncodable] = ["entity_id": HassRestClient.AnyEncodable(entityId)]
//        
//        // Optionally include temperature and hvacMode in the command if provided.
//        if let temp = temperature {
//            commandData["temperature"] = HassRestClient.AnyEncodable(temp)
//        }
//        if let mode = hvacMode {
//            commandData["hvac_mode"] = HassRestClient.AnyEncodable(mode.rawValue)
//        }
//        
//        // Create the DeviceCommand. The service might change based on the command's nature.
//        // For example, 'climate.set_temperature' might be used here, but adjust as needed.
//        let command = HassRestClient.DeviceCommand(service: "climate.set_temperature", entityId: entityId, data: commandData)
//        
//        HassAPIService.shared.sendCommand(entityId: entityId, hvacMode: hvacMode ?? .heat, temperature: temperature ?? 22) { result in
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(_):
//                    print("[WatchManager] Command sent successfully to \(entityId)")
//                case .failure(let error):
//                    print("[WatchManager] Error sending command to \(entityId): \(error)")
//                    self.errorMessage = "Failed to send command to \(entityId)"
//                }
//            }
//        }
//    }
//
//
//    func handleScriptAction(entityId: String) {
//        HassAPIService.shared.callScript(entityId: entityId) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success():
//                    print("[WatchManager] Script executed successfully")
//                    self?.lastCallStatus = .success
//                case .failure(let error):
//                    print("[WatchManager] Error executing script \(entityId): \(error)")
//                    self?.lastCallStatus = .failure
//                    self?.errorMessage = "Failed to execute script \(entityId)"
//                }
//            }
//        }
//    }
//}
