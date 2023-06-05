import Foundation

struct Geometry: Decodable {
    var date: String
    var type: String
    var coordinates: [Double]
}

struct Source: Identifiable, Decodable {
    var id: String
    var url: String
}

struct Event: Identifiable, Decodable {
    var id: String
    var title: String
    var description: String
    var link: String
    var categories: [Category]
    var sources: [Source]
    var geometries: [Geometry]
}

struct Initial: Decodable {
    var title: String
    var description: String
    var link: String
    var events: [Event]
}

typealias Events = [Event]

class loadEventsData: ObservableObject {
    var url: URL
    
    init(url: String) {
        self.url = URL(string: url)!
    }
    
    func loadAsync() async throws -> Events? {
        let urlRequest = URLRequest(url: self.url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading categories")
        }
            
        let eventsResponse = try JSONDecoder().decode(Initial.self, from: data)

        return eventsResponse.events
    }
}
