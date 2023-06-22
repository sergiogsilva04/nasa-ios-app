import SwiftUI

class APODViewModel: ObservableObject {
    @Published var apod: APOD? = nil
    @Published var isShowingLoadingDialog = false
    @Published var isShowingNetworkDialog = false
    @Published var currentMediaType = ""
    @Published var currentDate = Date() {
        didSet {
            self.getData()
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
        self.formatter.dateFormat = "yyyy-MM-dd"

        self.getData()
    }

    func getData(random: Bool = false) {
        if (Common.checkInternetAvailability()) {
            self.isShowingLoadingDialog = true
            
            Task {
                do {
                    print("before getapod")
                    try await self.getAPOD(random: random)
                    
                    self.isShowingLoadingDialog = false
                    print("after getapod")
                    
                } catch {
                    self.isShowingLoadingDialog = false
                    print("Erro: \(error)")
                }
            }
        }
    }

    func getAPOD(random: Bool = false) async throws {
        print("started getapod")
        var url = "https://api.nasa.gov/planetary/apod?api_key=\(self.API_KEY)"

        url.append(random ? "&count=1" : "&date=\(self.formatter.string(from: self.currentDate))")
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("error loading post")
            
            return
        }
        
        let decoder = JSONDecoder()
        
        if (random) {
            self.apod = try decoder.decode(APODS.self, from: data)[0]
            self.currentDate = formatter.date(from: self.apod!.date)!
            
        } else {
            self.apod = try decoder.decode(APOD.self, from: data)
        }
        
        currentMediaType = apod!.media_type
        
        print("finished getapod")
    }
    
    func isPreviousDayAvailable() -> Bool {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)
        
        return previousDate != nil && previousDate! <= self.dateRange.lowerBound
    }
        
    func isNextDayAvailable() -> Bool {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate)
        
        return nextDate != nil && nextDate! >= self.dateRange.upperBound
    }
}
