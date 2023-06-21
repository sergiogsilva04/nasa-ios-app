import Foundation

typealias Posts = [Post]

struct Post: Decodable {
    var id: String
    var date: String
    var url: String
}
