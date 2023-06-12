import SwiftUI

class ContentViewModel: ObservableObject, listsData {
    @Published var eventsList: Events = []
    @Published var categoriesList: Categories = []
    @Published var selectedCategoryId: Category.ID = "all"
    @Published var selectedEventsStatus: String = "On going"
    @Published var isShowingCategoryInfo = false
    
    let eventsLimit = 20
    let eventsStatus: [String] = ["On going", "Finished", "All"]
    let dateFormatter = DateFormatter()
    
    var filteredEvents: [Event] {
        let filteredByCategory = selectedCategoryId == "all" ? eventsList : eventsList.filter { $0.categories.first?.id == selectedCategoryId }
            
        switch (selectedEventsStatus) {
            case "On going":
                return filteredByCategory.filter { $0.closed == nil }
                
            case "Finished":
                return filteredByCategory.filter { $0.closed != nil }
                
            default:
                return filteredByCategory
        }
    }
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        Task {
            do {
                try await getEvents()
                try await getCategories()
                
            } catch {
                print(error)
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
    
    func getFormattedDate(date: String) -> Date? {
        dateFormatter.dateFormat = "dd/MM/yyyy | HH:mm:ss"
        
        return dateFormatter.date(from: date)
    }
}
