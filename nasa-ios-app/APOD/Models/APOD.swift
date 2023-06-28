import Foundation

/// Enum representing the media type of an Astronomy Picture of the Day (APOD) item.
enum ApodMediaType: String {
    case image, video, unknown
}

/// A structure representing an Astronomy Picture of the Day (APOD) item.
struct Apod: Decodable {
    let date: String         // The date of the APOD item.
    let explanation: String  // The explanation or description of the APOD item.
    let media_type: String   // The media type of the APOD item (image, video).
    let title: String        // The title of the APOD item.
    let url: String          // The URL of the APOD item.
}

/// A type alias representing an array of APOD items.
typealias Apods = [Apod]
