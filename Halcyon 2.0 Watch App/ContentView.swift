import SwiftUI

struct ContentView: View {
    @State private var selectedTemperature: Double = 22
    @State private var selectedRoom: Room = .chambre
    @State private var temperaturesForRooms: [Room: Double] = Room.allCases.reduce(into: [:]) { $0[$1] = 22 }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color("Background").ignoresSafeArea()
                    VStack(spacing: 0) {
                        TabView(selection: $selectedRoom) {
                            ForEach(Room.allCases, id: \.self) { room in
                                ThermostatView(temperature: self.bindingFor(room: room), room: room)
                                    .tag(room)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(width: geometry.size.width, height: geometry.size.width)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(selectedRoom.rawValue)
        }
    }

    private func bindingFor(room: Room) -> Binding<Double> {
        Binding(
            get: { self.temperaturesForRooms[room, default: 22] },
            set: { self.temperaturesForRooms[room] = $0 }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ClimateViewModel()) // This is where you add the environment object
    }
}
