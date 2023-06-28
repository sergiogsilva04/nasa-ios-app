import Foundation

/// A structure representing an EPIC (Earth Polychromatic Imaging Camera) image.
struct Epic: Decodable {
    var image: String    // The URL of the EPIC image.
}

/// A type alias representing an array of EPIC images.
typealias Epics = [Epic]
