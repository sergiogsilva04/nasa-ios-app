import SwiftUI

class ContentViewModel: ObservableObject {
    //@StateObject var load = loadData(url: "https://api.nasa.gov/planetary/earth/")
    @Published var imageUrl = ""
    @Published var latitude: Double = 38.76857711768943
    @Published var longitude: Double = -9.160021831225064
    @Published var post: Post? = nil
    @Published var currentDate = Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 25))!
    
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
                try await getPost()
                
            } catch {
                print(error)
            }
            
        }
    }
    
    func getPost() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://api.nasa.gov/planetary/earth/assets?lon=\("\(LocationData.shared.longitude)")&lat=\("\(LocationData.shared.latitude)")&date=\(currentDate.dataFormatada())&dim=0.15&api_key=KDkQL7vGfDSGqKiPKUFUp756bwoIL1apHrc5pwQu")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error loading post")
            return
        }

        self.post = try JSONDecoder().decode(Post.self, from: data)
    }
    
    func getRandomPost() async throws {
                    randomDateBetween(startDateComponents: DateComponents(year: 2013, month: 3, day: 1), endDateComponents: DateComponents(year: 2021, month: 12, day: 25))
                    MapViewModel().getRandomLocation()
                    getData()
            
        
        
    }
    
    func randomDateBetween(startDateComponents: DateComponents, endDateComponents: DateComponents) {
        // Check if the start date is later than the end date
        guard let startDate = Calendar.current.date(from: startDateComponents),
              let endDate = Calendar.current.date(from: endDateComponents),
              startDate < endDate else {
            return
        }
        
        // Get the start and end date's time intervals
        let startInterval = startDate.timeIntervalSince1970
        let endInterval = endDate.timeIntervalSince1970
        
        // Generate a random time interval within the range
        print((startInterval...endInterval))
        
        let randomInterval = TimeInterval.random(in:  (startInterval)...(endInterval))
        print(randomInterval)
        // Create a date using the random interval
        let randomDate = Date(timeIntervalSince1970: randomInterval)
        print(randomDate)
        
        
        currentDate = randomDate
    }
    
}

class LocationData: ObservableObject, Identifiable {
    static let shared = LocationData()
    
    let id = UUID()
    @Published var latitude: Double
    @Published var longitude: Double
        
    init() {
        latitude = 38.76857711768943
        longitude = -9.160021831225064
    }
}
