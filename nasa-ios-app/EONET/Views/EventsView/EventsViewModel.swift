import SwiftUI

class EventsViewModel: ObservableObject, listsData {
    @Published var eventsList: Events = []
    @Published var categoriesList: Categories = []
    @Published var selectedCategoryId: Category.ID = "all" as Category.ID
    @Published var selectedEventsStatus: String = "On going"
    @Published var isShowingCategoryInfoDialog: Bool = false
    @Published var isShowingLoadingDialog: Bool = true
    @Published var isShowingNetworkDialog: Bool = false
    @Published var startDateFilter: Date = Calendar.current.date(from: DateComponents(year: 1980, month: 1, day: 10))!
    @Published var endDateFilter: Date = Date()

    let eventsLimit: Int = 20 // max until fix geomtry error = 2000
    let eventsStatus: [String] = ["On going", "Finished", "All"]
    let dateFormatter: DateFormatter = DateFormatter()
    let startDateFilterRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1980, month: 1, day: 10)
        
        return calendar.date(from: startDateComponents)!...Date()
    }()
    
    var filteredEvents: [Event] {
        var filteredList = selectedCategoryId == "all" ? eventsList : eventsList.filter { $0.categories.first?.id == selectedCategoryId }
        
        filteredList = filteredList.filter {
            dateFormatter.date(from: $0.geometry.first!.date)! > startDateFilter && dateFormatter.date(from: $0.geometry.first!.date)! < endDateFilter
        }
            
        switch (selectedEventsStatus) {
            case "On going":
                return filteredList.filter { $0.closed == nil }
                
            case "Finished":
                return filteredList.filter { $0.closed != nil }
                
            default:
                return filteredList
        }
    }
    
    init() {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        self.getData()
    }

    func getData() {
        if (Common.checkInternetAvailability()) {
            Task {
                do {
                    try await getEvents()
                    try await getCategories()
                    
                    isShowingLoadingDialog = false
                    
                } catch {
                    print(error)
                }
            }
        }
    }

    func getEvents() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://eonet.gsfc.nasa.gov/api/v3/events?status=all&limit=\(eventsLimit)")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading events")
        }

        self.eventsList = try JSONDecoder().decode(EventsResponse.self, from: data).events
    }
    
    func getCategories() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://eonet.gsfc.nasa.gov/api/v3/categories")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading events")
        }
        
        self.categoriesList = try JSONDecoder().decode(CategoryResponse.self, from: data).categories
        self.categoriesList.insert(Category(id: "all", title: "All categories", description: "All categories", link: "https://eonet.gsfc.nasa.gov/api/v3/events?status=all&limit=\(eventsLimit)"), at: 0)
        self.selectedCategoryId = "all"
    }
    
    func getCategoryById(categoryId: String) -> Category? {
        return categoriesList.filter { $0.id == categoryId }.first
    }
}
