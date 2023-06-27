import SwiftUI
import WebKit

class ApodViewModel: ObservableObject {
    @Published var apod: Apod? = nil
    @Published var isShowingLoadingDialog = false
    @Published var isShowingNetworkDialog = false
    @Published var currentMediaType: ApodMediaType = .unknown
    @Published var currentAsyncImageUrl = ""
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
    let dateFormatter = DateFormatter()
    
    enum APIError: Error {
        case gatewayTimeout
    }

    init() {
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.getData()
    }

    func getData(random: Bool = false) {
        DispatchQueue.main.async {
            self.currentAsyncImageUrl = ""
        }
        
        if (Common.checkInternetAvailability()) {
            DispatchQueue.main.async {
                self.isShowingLoadingDialog = true
            }
            
            Task {
                do {
                    try await self.getApod(random: random)
                    
                    DispatchQueue.main.async {
                        self.isShowingLoadingDialog = false
                    }
                    
                } catch {
                    self.getData(random: random)
                    
                    print("Erro: \(error)")
                }
            }
        }
    }

    func getApod(random: Bool = false) async throws {
        var url = "https://api.nasa.gov/planetary/apod?api_key=\(self.API_KEY)"

        url.append(random ? "&count=1" : "&date=\(self.dateFormatter.string(from: self.currentDate))")
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            let response = (response as? HTTPURLResponse)
            
            DispatchQueue.main.async {
                self.isShowingLoadingDialog = false
            }
            
            if (response?.statusCode == 504) {
                print("erro 504")
                self.getData(random: random)
                
                DispatchQueue.main.async {
                    self.isShowingLoadingDialog = true
                }
                
            } else {
                print("Error loading post: \(response!)")
            }
            
            return
        }
        
        let decoder = JSONDecoder()
        
        if (random) {
            self.apod = try decoder.decode(Apods.self, from: data)[0]

            DispatchQueue.main.async {
                self.currentDate = self.dateFormatter.date(from: self.apod!.date)!
            }
            
        } else {
            self.apod = try decoder.decode(Apod.self, from: data)
        }
        
        DispatchQueue.main.async {
            self.currentMediaType = ApodMediaType(rawValue: self.apod!.media_type) ?? .unknown
            self.currentAsyncImageUrl = self.apod!.url
        }
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

struct Video: UIViewRepresentable {
    let videoUrl: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let youtubeURL = URL(string: videoUrl) else {
            return
        }
                
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}
