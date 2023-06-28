import SwiftUI

/// A view model for managing the events data and state in the EventsView.
class EventsViewModel: ObservableObject, listsData {
    // MARK: - Published Properties
    
    /// The list of events.
    @Published var eventsList: Events = []
    
    /// The list of categories.
    @Published var categoriesList: Categories = [Category(id: "all", title: "All categories", description: "All categories", link: "https://eonet.gsfc.nasa.gov/api/v3/events?status=all")]
    
    /// The ID of the selected category.
    @Published var selectedCategoryId: Category.ID = "all" as Category.ID
    
    /// The selected events status.
    @Published var selectedEventsStatus: String = "On going"
    
    /// A flag indicating whether the category info dialog is being shown.
    @Published var isShowingCategoryInfoDialog: Bool = false
    
    /// A flag indicating whether the loading dialog is being shown.
    @Published var isShowingLoadingDialog: Bool = true
    
    /// A flag indicating whether the network dialog is being shown.
    @Published var isShowingNetworkDialog: Bool = false
    
    /// A flag indicating whether the filters dialog is being shown.
    @Published var isShowingFiltersDialog: Bool = false
    
    /// A flag indicating whether the list mode is active.
    @Published var isListModeActive: Bool = true
    
    /// A flag indicating whether the prior days week filter is active.
    @Published var isPriorDaysWeekActive: Bool = false
    
    /// A flag indicating whether the prior days month filter is active.
    @Published var isPriorDaysMonthActive: Bool = false
    
    /// A flag indicating whether the prior days year filter is active.
    @Published var isPriorDaysYearActive: Bool = false
    
    /// The number of prior days to filter.
    @Published var priorDaysFilter: Int = 0
    
    /// The start date filter.
    @Published var startDateFilter: Date = Calendar.current.date(from: DateComponents(year: 1980, month: 1, day: 10))!
    
    /// The end date filter.
    @Published var endDateFilter: Date = Date()
    
    // MARK: - Constants
    
    /// The maximum number of events to fetch.
    let eventsLimit: Int = 100 // max until fix geomtry error = 2000
    
    /// The available events statuses.
    let eventsStatus: [String] = ["On going", "Finished", "All"]
    
    /// The date formatter for parsing and formatting dates.
    let dateFormatter: DateFormatter = DateFormatter()
    
    /// The range for the start date filter.
    let startDateFilterRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1980, month: 1, day: 10)
        
        return calendar.date(from: startDateComponents)!...Date()
    }()
    
    // MARK: - Computed Properties
    
    /// The filtered list of events based on the selected category, date filters, and event status.
    var filteredEvents: [Event] {
        var filteredList = self.selectedCategoryId == "all" ? self.eventsList : self.eventsList.filter { $0.categories.first?.id == self.selectedCategoryId }
        
        if (self.priorDaysFilter == 0) {
            filteredList = filteredList.filter {
                self.dateFormatter.date(from: $0.geometry.first!.date)! > self.startDateFilter && dateFormatter.date(from: $0.geometry.first!.date)! < self.endDateFilter
            }
        }
        
        if (self.priorDaysFilter > 0) {
            filteredList = filteredList.filter {
                isEventInPast(date: self.dateFormatter.date(from: $0.geometry.first!.date)!)
            }
        }
        
        switch (self.selectedEventsStatus) {
            case "On going":
                return filteredList.filter { $0.closed == nil }
                
            case "Finished":
                return filteredList.filter { $0.closed != nil }
                
            default:
                return filteredList
        }
    }
    
    // MARK: - Initializer
    
    init() {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        self.getData()
    }
    
    // MARK: - Methods
    
    /// Fetches the events and categories data.
    func getData() {
        if (Common.checkInternetAvailability()) {
            Task {
                do {
                    try await getEvents()
                    try await getCategories()
                    
                    DispatchQueue.main.async {
                        self.isShowingLoadingDialog = false
                    }
                
                } catch {
                    print(error)
                }
            }
        }
    }
    
    /// Fetches the events data from the API.
    func getEvents() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://eonet.gsfc.nasa.gov/api/v3/events?status=all&limit=\(self.eventsLimit)")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading events")
        }
        
        self.eventsList.append(contentsOf: try JSONDecoder().decode(EventsResponse.self, from: data).events)
    }
    
    /// Fetches the categories data from the API.
    func getCategories() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://eonet.gsfc.nasa.gov/api/v3/categories")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading events")
        }
        
        self.categoriesList.append(contentsOf: (try JSONDecoder().decode(CategoryResponse.self, from: data).categories))
    }
    
    /// Retrieves a category by its ID.
    func getCategoryById(categoryId: String) -> Category? {
        return categoriesList.filter { $0.id == categoryId }.first
    }
    
    /// Clears all the applied filters.
    func clearFilters() {
        self.isPriorDaysWeekActive = false
        self.isPriorDaysMonthActive = false
        self.isPriorDaysYearActive = false
        self.priorDaysFilter = 0
        self.startDateFilter = Calendar.current.date(from: DateComponents(year: 1980, month: 1, day: 10))!
        self.endDateFilter = Date()
    }
    
    /// Checks if an event is in the past based on the given date.
    func isEventInPast(date: Date) -> Bool {
        let components = Calendar.current.dateComponents([.day], from: date, to: self.endDateFilter)
        
        return components.day != nil && components.day! <= self.priorDaysFilter
    }
}

struct EventsViewModel_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
