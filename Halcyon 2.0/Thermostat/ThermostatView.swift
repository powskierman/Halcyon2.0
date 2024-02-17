import SwiftUI

struct ThermostatView: View {
    @Binding var temperature: Double
    var room: Room
    // Access HassClimateService as an environment object
    @EnvironmentObject var climateService: HassClimateService
    
    // Other properties remain private as they do not need to be exposed
    private let baseRingSize: CGFloat = 180
    private let baseOuterDialSize: CGFloat = 170
    private let minTemperature: CGFloat = 10
    private let maxTemperature: CGFloat = 30
    
    // Calculated properties can remain private or internal if not needed outside
    private var ringSize: CGFloat { baseRingSize }
    private var outerDialSize: CGFloat { baseOuterDialSize }
    
    // Dependency injection via initializer
    init(temperature: Binding<Double>, room: Room) {
        self._temperature = temperature
        self.room = room
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Existing UI elements...
                Circle()
                    .trim(from: 0.25, to: min(CGFloat(temperature) / 40, 0.75))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("Temperature Ring 1"), Color("Temperature Ring 2")]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(90))
                    .animation(.linear(duration: 1), value: CGFloat(temperature) / 40)
                
                ThermometerDialView(outerDialSize: outerDialSize, degrees: CGFloat(temperature) / 40 * 360)
                
                ThermometerSummaryView(temperature: CGFloat(temperature))
            }
            .focusable()
            .digitalCrownRotation(
                $temperature,
                from: Double(minTemperature),
                through: Double(maxTemperature),
                by: 0.5,
                sensitivity: .low,
                isContinuous: true
            )
            .onChange(of: temperature) { newTemperature in
                postTemperatureUpdate(newTemperature: newTemperature)
            }
        }
    }
    
    private func postTemperatureUpdate(newTemperature: Double) {
        let entityId = room.entityId // Ensure `room` is accessible here
        HassClimateService.shared.sendTemperatureUpdate(entityId: entityId, temperature: newTemperature) { result in
            DispatchQueue.main.async { // Ensure UI updates are performed on the main thread
                switch result {
                case .success():
                    print("Temperature successfully updated for \(self.room.rawValue)")
                case .failure(let error):
                    print("Failed to update temperature for \(self.room.rawValue): \(error)")
                }
            }
        }
    }
}
