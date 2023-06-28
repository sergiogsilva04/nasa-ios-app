import SwiftUI

class EarthViewModel: ObservableObject {
    @Published var earth: Earth? = nil
    @Published var latitude: Double = 38.76857711768943
    @Published var longitude: Double = -9.160021831225064
    @Published var isShowingLoadingDialog: Bool = false
    @Published var isShowingNetworkDialog: Bool = false
    @Published var currentDate = Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 25))!
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 2013, month: 3, day: 1)
        let endDateComponents = DateComponents(year: 2021, month: 12, day: 25)
        
        return calendar.date(from: startDateComponents)!...calendar.date(from: endDateComponents)!
    }()
    
    init() {
        //getData()
    }
    
    func getData() {
        Task{
            do {
                try await getEarth()
                
                DispatchQueue.main.async {
                    self.isShowingLoadingDialog = false
                }
                
            } catch {
                print(error)
            }
            
        }
    }
    
    func getEarth() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://api.nasa.gov/planetary/earth/assets?lon=\("\(LocationData.shared.longitude)")&lat=\("\(LocationData.shared.latitude)")&date=\(currentDate.format(format: "yyyy-MM-dd"))&dim=0.15&api_key=KDkQL7vGfDSGqKiPKUFUp756bwoIL1apHrc5pwQu")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error loading earth")
            return
        }

        self.earth = try JSONDecoder().decode(Earth.self, from: data)
    }
    
    func getRandomPost() async throws {
        randomDateBetween(startDateComponents: DateComponents(year: 2013, month: 3, day: 1), endDateComponents: DateComponents(year: 2021, month: 12, day: 25))
        
        MapViewModel().getRandomLocation()
        
        getData()
    }
    
    func randomDateBetween(startDateComponents: DateComponents, endDateComponents: DateComponents) {
        guard let startDate = Calendar.current.date(from: startDateComponents), let endDate = Calendar.current.date(from: endDateComponents), startDate < endDate else {
            return
        }
        
        let randomInterval = TimeInterval.random(in:  (startDate.timeIntervalSince1970)...(endDate.timeIntervalSince1970))
        let randomDate = Date(timeIntervalSince1970: randomInterval)
    
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
