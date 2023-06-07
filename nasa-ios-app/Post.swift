import Foundation

typealias Posts = [Post]

struct Post: Decodable {
    var id: String
    var date: String
    var url: String
}
enum MyError: Error {
    case customError
}

class loadData: ObservableObject {
    @Published var date = Date(){
        didSet{
            composeURL()

        }
    }
    
    var url: URL
    
    init(url: String) {
        self.url = URL(string: url)!
        date =  Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    }
    
    func composeURL(){
        self.url = URL(string: "https://api.nasa.gov/planetary/earth/assets?lon=100.75&lat=1.5&date=\(date.dataFormatada())&dim=0.15&api_key=KDkQL7vGfDSGqKiPKUFUp756bwoIL1apHrc5pwQu")!
        print(self.url)
    }
    
    
    
    func loadAsync() async throws -> Post? {
        
        composeURL()
        
        let urlRequest = URLRequest(url: self.url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Erro no statusCode -> \((response as? HTTPURLResponse)?.statusCode)")
            throw MyError.customError
        }
        
        let myData = try JSONDecoder().decode(Post.self, from: data)
        
        return myData
    }
}
