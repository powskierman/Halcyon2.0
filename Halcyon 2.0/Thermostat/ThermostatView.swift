import SwiftUI

enum Room: String, CaseIterable {
    case Chambre = "Chambre"
    case TVRoom = "TV Room"
    case Cuisine = "Cuisine"
    case Salon = "Salon"
    case Amis = "Amis"
}

struct ThermometerView: View {
    var room: Room
    private let baseRingSize: CGFloat = 180
    private let baseOuterDialSize: CGFloat = 170
    private let minTemperature: CGFloat = 10
    private let maxTemperature: CGFloat = 30
    
    @State private var temperaturesForRooms: [Room: CGFloat] = [:]
    @State private var currentTemperature: CGFloat = 22
    
    private var ringSize: CGFloat { baseRingSize }
    private var outerDialSize: CGFloat { baseOuterDialSize }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ThermometerScaleView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Circle()
                    .trim(from: 0.25, to: min(currentTemperature / 40, 0.75))
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
                    .animation(.linear(duration: 1), value: currentTemperature / 40)
                
                ThermometerDialView(outerDialSize: outerDialSize, degrees: currentTemperature / 40 * 360)
                
                ThermometerSummaryView(temperature: currentTemperature)
            }
            .focusable()
            .digitalCrownRotation(
                $currentTemperature,
                from: minTemperature,
                through: maxTemperature,
                by: 0.5,
                sensitivity: .low,
                isContinuous: true
            )
            .onAppear {
                currentTemperature = temperaturesForRooms[room, default: 22]
            }
            .onChange(of: room) { [self] _ in
                temperaturesForRooms[room] = currentTemperature
                currentTemperature = temperaturesForRooms[room, default: 22]
            }
            .onChange(of: currentTemperature) { newTemperature in
                temperaturesForRooms[room] = newTemperature
            }
        }
    }
}

struct ThermometerView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerView(room: .Chambre)
    }
}
