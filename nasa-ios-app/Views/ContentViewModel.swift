import SwiftUI

class ContentViewModel: ObservableObject {
    //@StateObject var load = loadData(url: "https://api.nasa.gov/planetary/earth/")
    @Published var imageUrl = ""
    @Published var posts: posts? = nil
    @Published var currentDate = Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 25))!
    
    let API_KEY = "YbwAymq2uzB99A8GM9I8mSsHJ1BiQKR0OAiCd8Ts"
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 2013, month: 3, day: 1)
        let endDateComponents = DateComponents(year: 2021, month: 12, day: 25)
        
        return calendar.date(from: startDateComponents)!...calendar.date(from: endDateComponents)!
    }()
    
    init() {
        getData()
    }
    
    func getData() {
        Task{
            do {
                try await getPictures()
                
            } catch {
                print(error)
            }
            
        }
    }
    
    func getPictures() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2015-6-3&api_key=\(API_KEY)")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error loading post")
            return
        }

        self.posts = try JSONDecoder().decode(fotos.self, from: data).photos
    }
}

class LocationData: ObservableObject, Identifiable {
    static let shared = LocationData()
    
    let id = UUID()
    @Published var latitude: Double
    @Published var longitude: Double
        
    private init() {
        latitude = 38.76857711768943
        longitude = -9.160021831225064
    }
}
