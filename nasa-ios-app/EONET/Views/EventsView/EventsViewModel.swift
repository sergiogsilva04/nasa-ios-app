import SwiftUI

class EventsViewModel: ObservableObject, listsData {
    @Published var eventsList: Events = []
    @Published var categoriesList: Categories = [Category(id: "all", title: "All categories", description: "All categories", link: "https://eonet.gsfc.nasa.gov/api/v3/events?status=all")]
    @Published var selectedCategoryId: Category.ID = "all" as Category.ID
    @Published var selectedEventsStatus: String = "On going"
    @Published var isShowingCategoryInfoDialog: Bool = false
    @Published var isShowingLoadingDialog: Bool = true
    @Published var isShowingNetworkDialog: Bool = false
    @Published var isShowingFiltersDialog: Bool = false
    @Published var isListModeActive: Bool = true
    @Published var isPriorDaysWeekActive: Bool = false
    @Published var isPriorDaysMonthActive: Bool = false
    @Published var isPriorDaysYearActive: Bool = false
    @Published var priorDaysFilter: Int = 0
    @Published var startDateFilter: Date = Calendar.current.date(from: DateComponents(year: 1980, month: 1, day: 10))!
    @Published var endDateFilter: Date = Date()
    
    let eventsLimit: Int = 100 // max until fix geomtry error = 2000
    let eventsStatus: [String] = ["On going", "Finished", "All"]
    let dateFormatter: DateFormatter = DateFormatter()
    let startDateFilterRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 1980, month: 1, day: 10)
        
        return calendar.date(from: startDateComponents)!...Date()
    }()
    
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
                    
                    DispatchQueue.main.async {
                        self.isShowingLoadingDialog = false
                    }
                
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getEvents() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://eonet.gsfc.nasa.gov/api/v3/events?status=all&limit=\(self.eventsLimit)")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading events")
        }
        
        self.eventsList.append(contentsOf: try JSONDecoder().decode(EventsResponse.self, from: data).events)
    }
    
    func getCategories() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://eonet.gsfc.nasa.gov/api/v3/categories")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error loading events")
        }
        
        self.categoriesList.append(contentsOf: (try JSONDecoder().decode(CategoryResponse.self, from: data).categories))
    }
    
    func getCategoryById(categoryId: String) -> Category? {
        return categoriesList.filter { $0.id == categoryId }.first
    }
    
    func clearFilters() {
        self.isPriorDaysWeekActive = false
        self.isPriorDaysMonthActive = false
        self.isPriorDaysYearActive = false
        self.priorDaysFilter = 0
        self.startDateFilter = Calendar.current.date(from: DateComponents(year: 1980, month: 1, day: 10))!
        self.endDateFilter = Date()
    }
    
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
