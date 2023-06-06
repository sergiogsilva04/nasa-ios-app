import SwiftUI

struct ContentView: View {
    @StateObject var loadEvents = loadEventsData(url: "https://eonet.gsfc.nasa.gov/api/v3/events?limit=3")
    @State private var events: Events = []
    
    func loadEventsAsync() async {
        do {
            events = try await loadEvents.loadAsync()!
            
        } catch {
            print("erro: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Eventos")
                .font(.system(size: 40))
            
            NavigationView {
                List(events) { event in
                    NavigationLink {
                        Text("teste")
                        
                    } label: {
                        EventRow(event: event)
                    }
                    .listRowBackground(event.closed == nil ? Color.green : Color.red)
                }
                
            }.task {
                await loadEventsAsync()
                
                print(events.count)
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
//
//Task {
//    do {
//        var events = try await loadEvents.loadAsync()
//
//        ForEach (events) { event in
//            NavigationLink {
//                Text("teste")
//
//            } label: {
//                EventListitem(event: event)
//            }
//        }
//
//    } catch {
//        print("error \(error)")
//    }
//}
