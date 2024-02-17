import Foundation
import Combine
import HassWatchFramework

class HassClimateService: ObservableObject {
    static let shared = HassClimateService()
    private let clientService: HassClientService
    
    @Published var tempSet: Int = 22
    @Published var fanSpeed: String = "auto"
    @Published var halcyonOff: Bool = true
    @Published var halcyonMode: String = "cool"
    @Published var errorMessage: String?
    
    private var lastSentTemperature: Double?
    
    init(clientService: HassClientService = .shared) {
        self.clientService = clientService
        print("HassClimateService initialized.")
    }
    
    func updateTemperatureIfNeeded(entityId: String, newTemperature: Double) {
        guard self.lastSentTemperature != nil else {
            // If no temperature has been sent yet, send the initial value
            sendTemperatureUpdate(entityId: entityId, temperature: newTemperature) { result in
                self.lastSentTemperature = newTemperature
                return
            }
            
            let temperatureDifference = abs(newTemperature - Double(self.tempSet))
            if temperatureDifference >= 1.0 {
                // Send the update only if the difference is 1 degree or more
                sendTemperatureUpdate(entityId: entityId, temperature: newTemperature) { result in
                    self.lastSentTemperature = newTemperature // Update the last sent temperature
                    self.tempSet = Int(newTemperature) // Update the published temperature set point
                }
            }
            return
        }
    }
        
        // Sets the temperature for a specified climate entity
        public func sendTemperatureUpdate(entityId: String, temperature: Double, completion: @escaping (Result<Void, Error>) -> Void) {
            print("Attempting to set temperature for entityId: \(entityId) to \(temperature)°C.")
            let newState = "{\"temperature\": \(temperature)}"
            
            clientService.sendCommand(entityId: entityId, newState: newState) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Temperature set successfully for \(entityId)")
                        completion(.success(())) // Notify caller of success
                    case .failure(let error):
                        print("Failed to set temperature for \(entityId): \(error)")
                        completion(.failure(error)) // Pass the error to the caller
                    }
                }
            }
        }
        
        
        func sendThermostatCommand(entityId: String, newState: String) {
            // Wrapper for directly sending thermostat commands, adjusting for consolidated logic
            sendTemperatureUpdate(entityId: entityId, temperature: Double(tempSet)) { result in
            }
            
            // Additional functionalities leveraging HassRestClient as before
        }
    }

