import Foundation

struct Apod: Decodable {
    let date: String
    let explanation: String
    let media_type: String
    let title: String
    let url: String
}

typealias Apods = [Apod]
