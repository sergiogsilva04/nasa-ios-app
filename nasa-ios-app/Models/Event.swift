import Foundation

struct Geometry: Decodable {
    var magnitudeValue: Double?
    var magnitudeUnit: String?
    var date: String
    var type: String
    var coordinates: [Double]
}

struct Source: Identifiable, Decodable {
    var id: String
    var url: String
}

struct Category: Identifiable, Decodable {
    var id: String
    var title: String
}

struct Event: Identifiable, Decodable {
    var id: String
    var title: String
    var description: String?
    var link: String
    var closed: String?
    var categories: [Category]
    var sources: [Source]
    var geometry: [Geometry]
}

struct EventsResponse: Decodable {
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
            fatalError("Error loading events")
        }

        let eventsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)

        return eventsResponse.events
    }
}
