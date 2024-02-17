import Foundation
import Combine // Import Combine for ObservableObject
import HassWatchFramework

// Assuming HassClientService and HassRestClient are part of your framework
class HassClimateService: ObservableObject {
    private let clientService: HassClientService
    static let shared = HassClimateService()
    
    init(clientService: HassClientService = .shared) {
        self.clientService = clientService
        print("HassClimateService initialized.")
    }
    
    // Sets the temperature for a specified climate entity
    func setTemperature(entityId: String, temperature: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the payload for setting the temperature
        print("Attempting to set temperature for entityId: \(entityId) to \(temperature)°C.")
        let newState = "{\"temperature\": \(temperature)}"
        
        // Use HassClientService to send the command
        clientService.sendCommand(entityId: entityId, newState: newState) { result in
            switch result {
            case .success(_):
                print("Temperature set successfully")
                completion(.success(()))
            case .failure(let error):
                print("Failed to set temperature: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Changes the HVAC mode for a specified climate entity
    func setHVACMode(entityId: String, mode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct the payload for setting the HVAC mode
        let newState = "{\"hvac_mode\": \"\(mode)\"}"
        
        // Use HassClientService to send the command
        clientService.sendCommand(entityId: entityId, newState: newState) { result in
            switch result {
            case .success(_):
                print("HVAC mode set successfully")
                completion(.success(()))
            case .failure(let error):
                print("Failed to set HVAC mode: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Fetches the current state of a specified climate entity
    func fetchClimateState(entityId: String, completion: @escaping (Result<HassRestClient.DeviceState, Error>) -> Void) {
        clientService.fetchDeviceState(deviceId: entityId, completion: completion)
    }
    
    // Additional climate-related functionalities as needed...
}
