import Foundation

struct Apod: Decodable {
    var date: String
    var explanation: String
    var media_type: String
    var title: String
    var url: String
}

typealias Apods = [Apod]
