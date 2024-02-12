//
//  ContentView.swift
//  SmartHomeThermostat
//
//  Created by Ali Mert Özhayta on 1.05.2022.
//

import SwiftUI

struct ContentView: View {
    // State variable to keep track of the selected room
    @State private var selectedRoom: Room = .Chambre // Default to the first room

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color("Background").ignoresSafeArea()
                    VStack(spacing: 0) {
                        TabView(selection: $selectedRoom) {
                            ForEach(Room.allCases, id: \.self) { room in
                                ThermometerView(room: room)
                                    .tag(room) // Ensure each view is uniquely tagged
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(width: geometry.size.width, height: geometry.size.width)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            // Use the selectedRoom for the navigation title
            .navigationTitle(selectedRoom.rawValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
