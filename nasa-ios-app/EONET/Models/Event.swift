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

struct EventCategory: Identifiable, Decodable {
    var id: String
    var title: String
}

struct Event: Identifiable, Decodable {
    var id: String
    var title: String
    var description: String?
    var link: String
    var closed: String?
    var categories: [EventCategory]
    var sources: [Source]
    var geometry: [Geometry]
}

struct EventsResponse: Decodable {
    var events: [Event]
}

typealias Events = [Event]
