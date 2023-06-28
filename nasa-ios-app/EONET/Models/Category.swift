import Foundation

/// Represents a category.
struct Category: Identifiable, Decodable, Hashable {
    var id: String              // The ID of the category
    var title: String           // The title of the category
    var description: String     // The description of the category
    var link: String            // The link associated with the category
}

/// Represents the response containing a list of categories.
struct CategoryResponse: Decodable {
    var categories: [Category]  // The list of categories
}

/// A typealias for a collection of categories.
typealias Categories = [Category]
