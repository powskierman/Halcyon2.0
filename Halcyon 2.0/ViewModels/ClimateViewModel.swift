import Foundation
import Combine
import HassWatchFramework

class ClimateViewModel: ObservableObject {
    static let shared = ClimateViewModel()
    private let clientService: HassAPIService
    
    @Published var tempSet: Int = 22
    @Published var fanSpeed: String = "auto"
    @Published var halcyonOff: Bool = true
    @Published var halcyonMode: String = "cool"
    @Published var errorMessage: String?
    
    private var lastSentTemperature: Double?
    private var updateTimer: Timer? // Ensure this is declared within the class scope
    private var lastUpdateTime: Date? // Ensure this is also declared within the class scope
    
    // Constants for throttling and debouncing
    private let updateInterval: TimeInterval = 2.0
    private let debounceInterval: TimeInterval = 0.5
    
    
    init(clientService: HassAPIService = .shared) {
        self.clientService = clientService
        print("HassClimateService initialized.")
    }
    
    public func updateTemperatureIfNeeded(entityId: String, newTemperature: Double) {
        // Invalidate and nullify the existing timer to reset the debounce mechanism
        updateTimer?.invalidate()
        updateTimer = nil
        
        // Start a new timer for debouncing
        updateTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            // Check if enough time has passed since the last update
            if let lastUpdate = self.lastUpdateTime, Date().timeIntervalSince(lastUpdate) < self.updateInterval {
                // If the update interval hasn't passed, do not proceed with the update.
                return
            }
            
            // Proceed with the update if the temperature change is significant (at least 1 degree)
            if self.lastSentTemperature == nil || abs(newTemperature - (self.lastSentTemperature ?? 0)) >= 1.0 {
                self.sendTemperatureUpdate(entityId: entityId, mode: .cool, temperature: Int(newTemperature)) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success():
                            print("Temperature set successfully for \(entityId) to \(newTemperature)°C")
                        case .failure(let error):
                            print("Failed to set temperature for \(entityId): \(error)")
                        }
                        // Update the last sent temperature and the last update time
                        self.lastSentTemperature = newTemperature
                        self.lastUpdateTime = Date()
                    }
                }
            }
        }
    }
    
    
    // Sets the temperature for a specified climate entity
    public func sendTemperatureUpdate(entityId: String, mode: HvacModes, temperature: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Attempting to set temperature for \(entityId) to \(temperature)°C with mode \(mode.rawValue).")
        
        // Construct the command data
        let commandData: [String: HassRestClient.AnyEncodable] = [
            "entity_id": HassRestClient.AnyEncodable(entityId),
            "temperature": HassRestClient.AnyEncodable(temperature),
            "hvac_mode": HassRestClient.AnyEncodable(mode.rawValue)
        ]
        
        // Create the DeviceCommand
        _ = HassRestClient.DeviceCommand(service: "climate.set_temperature", entityId: entityId, data: commandData)
        
        // Use HassAPIService to send the command
        clientService.sendCommand(entityId: entityId, hvacMode: .cool, temperature: temperature) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Temperature and mode set successfully for \(entityId)")
                    completion(.success(()))
                case .failure(let error):
                    print("Failed to set temperature and mode for \(entityId): \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
}
