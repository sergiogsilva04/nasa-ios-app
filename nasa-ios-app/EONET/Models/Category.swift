import Foundation

struct Category: Identifiable, Decodable, Hashable {
    var id: String
    var title: String
    var description: String
    var link: String
}

struct CategoryResponse: Decodable {
    var categories: [Category]
}

typealias Categories = [Category]
