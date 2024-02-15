//
//  ContentView.swift
//  SmartHomeThermostat
//
//  Created by Ali Mert Özhayta on 1.05.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedRoom: Room = .Chambre // Default to the first room
    @State private var temperaturesForRooms: [Room: Double] = Room.allCases.reduce(into: [:]) { $0[$1] = 22 } // Initialize with default temperature

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color("Background").ignoresSafeArea()
                    VStack(spacing: 0) {
                        TabView(selection: $selectedRoom) {
                            ForEach(Room.allCases, id: \.self) { room in
                                // Use a binding to the specific room's temperature
                                ThermometerView(temperature: bindingFor(room: room), room: room)
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

    // Helper function to get a binding to a room's temperature
    private func bindingFor(room: Room) -> Binding<Double> {
        Binding(
            get: { temperaturesForRooms[room, default: 22] }, // Provide a default value
            set: { temperaturesForRooms[room] = $0 }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
