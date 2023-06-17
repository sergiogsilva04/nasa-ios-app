import SwiftUI

class ContentViewModel: ObservableObject, listsData {
    @Published var eventsList: Events = []
    @Published var categoriesList: Categories = []
    @Published var selectedCategoryId: Category.ID = "all" as Category.ID
    @Published var selectedEventsStatus: String = "On going"
    @Published var isShowingCategoryInfo = false
    @Published var isShowingLoadingDialog = true
    
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

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
                .shadow(radius: 15)
            }
        }
    }

}
