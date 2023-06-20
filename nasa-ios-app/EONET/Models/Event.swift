import Foundation

struct Geometry: Decodable {
    var magnitudeValue: Double?
    var magnitudeUnit: String?
    var date: String
    var type: String
    var coordinates: [Double]
    // TODO: DAR FIX NO ERRO DE MISMATCH DO TIPO POLYGON E POINT
    /*
     https://chat.openai.com/c/9828c303-725a-408f-bf54-80c38bb90658
     https://emergency.copernicus.eu/mapping/list-of-components/EMSR324
     https://www.mongodb.com/docs/manual/reference/geojson/
     typeMismatch(Swift.Double, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "events", intValue: nil), _JSONKey(stringValue: "Index 2159", intValue: 2159), CodingKeys(stringValue: "geometry", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0), CodingKeys(stringValue: "coordinates", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "Expected to decode Double but found an array instead.", underlyingError: nil))
     */
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
