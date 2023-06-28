import Foundation

/// Represents the geometry of an event.
struct Geometry: Decodable {
    var magnitudeValue: Double?    // The magnitude value of the event
    var magnitudeUnit: String?     // The unit of the magnitude value
    var date: String               // The date of the event
    var type: String               // The type of the geometry
    var coordinates: [Double]      // The coordinates of the event
}

/// Represents the source of an event.
struct Source: Identifiable, Decodable {
    var id: String                 // The ID of the source
    var url: String                // The URL of the source
}

/// Represents the category of an event.
struct EventCategory: Identifiable, Decodable {
    var id: String                 // The ID of the category
    var title: String              // The title of the category
}

/// Represents an event.
struct Event: Identifiable, Decodable {
    var id: String                 // The ID of the event
    var title: String              // The title of the event
    var description: String?       // The description of the event
    var link: String               // The link associated with the event
    var closed: String?            // The date when the event was closed (optional)
    var categories: [EventCategory]// The categories associated with the event
    var sources: [Source]          // The sources associated with the event
    var geometry: [Geometry]       // The geometry associated with the event
}

/// Represents the response containing a list of events.
struct EventsResponse: Decodable {
    var events: [Event]            // The list of events
}

/// A typealias for a collection of events.
typealias Events = [Event]
