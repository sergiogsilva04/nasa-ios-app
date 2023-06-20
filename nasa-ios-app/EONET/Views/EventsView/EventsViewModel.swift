import SwiftUI

class EventsViewModel: ObservableObject, listsData {
    @Published var eventsList: Events = []
    @Published var categoriesList: Categories = []
    @Published var selectedCategoryId: Category.ID = "all" as Category.ID
    @Published var selectedEventsStatus: String = "On going"
    @Published var isShowingCategoryInfoDialog = false
    @Published var isShowingLoadingDialog = true
    @Published var isShowingNetworkDialog = false
    
    let eventsLimit = 20 // max until fix geomtry error = 2000
    let eventsStatus: [String] = ["On going", "Finished", "All"]
    
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
        getData()
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
