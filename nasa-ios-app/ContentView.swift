//
//  ContentView.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 24/05/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loadEvents = loadEventsData(url: "https://eonet.gsfc.nasa.gov/api/v2.1/events")
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, sergio!")
            
            Button("Load events") {
                Task {
                    let events = try await loadEvents.loadAsync()
                    
                    print(events!.first!)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
