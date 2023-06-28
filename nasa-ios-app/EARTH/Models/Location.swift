import Foundation

/// A structure representing a location with latitude and longitude coordinates.
struct Location: Identifiable {
    var id: UUID           // A unique identifier for the location.
    let latitude: Double   // The latitude coordinate of the location.
    let longitude: Double  // The longitude coordinate of the location.
}
