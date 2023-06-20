import Foundation

struct APOD: Decodable {
    var date: String
    var explanation: String
    var media_type: String
    var title: String
    var url: String
}

typealias APODS = [APOD]
