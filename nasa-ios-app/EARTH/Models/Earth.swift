import Foundation

/// A structure representing an Earth observation.
struct Earth: Decodable {
    var id: String      // The unique identifier of the Earth observation.
    var date: String    // The date of the Earth observation.
    var url: String     // The URL associated with the Earth observation.
}
