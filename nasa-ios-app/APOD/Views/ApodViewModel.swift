import SwiftUI
import WebKit

/// A view model for managing the Astronomy Picture of the Day (APOD) data and state in the ApodView.
class ApodViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The Astronomy Picture of the Day.
    @Published var apod: Apod? = nil
    
    /// A flag indicating whether the loading dialog is being shown.
    @Published var isShowingLoadingDialog = false
    
    /// A flag indicating whether the network dialog is being shown.
    @Published var isShowingNetworkDialog = false
    
    /// The current media type of the APOD.
    @Published var currentMediaType: ApodMediaType = .unknown
    
    /// The URL of the current asynchronous image.
    @Published var currentAsyncImageUrl = ""
    
    /// The current date for the APOD.
    @Published var currentDate = Date() {
        didSet {
            self.getData()
        }
    }
    
    // MARK: - Constants
    
    /// The API key for accessing the NASA API.
    let API_KEY = "E4mWO9s39at65FxNPKOYqcdUE1IgG0GSqmE1MZ84"
    
    /// The date range for fetching APOD data.
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1995, month: 6, day: 16)
        
        return calendar.date(from: startDateComponents)!...Date()
    }()
    
    // MARK: - Enum
    
    /// Possible API errors.
    enum APIError: Error {
        case gatewayTimeout
    }
    
    // MARK: - Initializer
    
    init() {
        self.getData()
    }
    
    // MARK: - Methods
    
    /// Fetches the APOD data.
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
                    
                    print("Error: \(error)")
                }
            }
        }
    }
    
    /// Fetches the APOD data from the API.
    func getApod(random: Bool = false) async throws {
        var url = "https://api.nasa.gov/planetary/apod?api_key=\(self.API_KEY)"
        
        url.append(random ? "&count=1" : "&date=\(self.currentDate.format(format: "yyyy-MM-dd"))")
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            let response = (response as? HTTPURLResponse)
            
            DispatchQueue.main.async {
                self.isShowingLoadingDialog = false
            }
            
            if (response?.statusCode == 504) {
                print("Error 504")
                self.getData(random: random)
                
                DispatchQueue.main.async {
                    self.isShowingLoadingDialog = true
                }
                
            } else {
                print("Error loading APOD: \(response!)")
            }
            
            return
        }
        
        let decoder = JSONDecoder()
        
        if (random) {
            self.apod = try decoder.decode(Apods.self, from: data)[0]
            
            DispatchQueue.main.async {
                self.currentDate = self.apod!.date.formatDate(format: "yyyy-MM-dd")!
            }
            
        } else {
            self.apod = try decoder.decode(Apod.self, from: data)
        }
        
        DispatchQueue.main.async {
            self.currentMediaType = ApodMediaType(rawValue: self.apod!.media_type) ?? .unknown
            self.currentAsyncImageUrl = self.apod!.url
        }
    }
    
    /// Checks if the previous day's APOD is available.
    func isPreviousDayAvailable() -> Bool {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)
        
        return previousDate != nil && previousDate! >= self.dateRange.lowerBound
    }
    
    /// Checks if the next day's APOD is available.
    func isNextDayAvailable() -> Bool {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate)
        
        return nextDate != nil && nextDate! <= self.dateRange.upperBound
    }
}

/// A SwiftUI view that represents a WKWebView for playing YouTube videos.
struct YoutubeVideoView: UIViewRepresentable {
    /// The URL of the YouTube video.
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
