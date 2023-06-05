import Foundation

struct Category: Identifiable, Decodable {
    var id: Int
    var title: String
}

typealias Categories = [Category]

class loadCategoriesData: ObservableObject {
    var url: URL
    
    init(url: String) {
        self.url = URL(string: url)!
    }
    
    func loadAsync() async throws -> Categories? {
        let urlRequest = URLRequest(url: self.url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading categories")
        }
        
        return try JSONDecoder().decode(Categories.self, from: data)
    }
}
