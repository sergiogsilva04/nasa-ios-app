import SwiftUI

class APODViewModel: ObservableObject {
    @Published var apod: APOD? = nil
    @Published var isShowingLoadingDialog = true
    @Published var isShowingNetworkDialog = false
    @Published var currentDate = Date() {
        didSet {
            getData()
        }
    }
    
    let API_KEY = "E4mWO9s39at65FxNPKOYqcdUE1IgG0GSqmE1MZ84"
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1995, month: 6, day: 16)
        
        return calendar.date(from: startDateComponents)!...Date()
    }()
    let formatter = DateFormatter()

    init() {
        formatter.dateFormat = "yyyy-MM-dd"

        getData()
    }

    func getData() {
        if (Common.checkInternetAvailability()) {
            Task {
                do {
                    try await getAPOD()
                    
                    isShowingLoadingDialog = false
                    
                } catch {
                    print(error)
                }
            }
        }
    }

    func getAPOD() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(API_KEY)&date=\(formatter.string(from: currentDate))")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading apod")
        }

        self.apod = try JSONDecoder().decode(APOD.self, from: data)
    }
}
