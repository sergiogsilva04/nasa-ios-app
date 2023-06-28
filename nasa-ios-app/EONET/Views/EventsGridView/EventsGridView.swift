import SwiftUI

/// A view that displays events in a grid layout.
struct EventsGridView: View {
    @StateObject var viewModel: EventsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(177)),
                    GridItem(.fixed(177))
                    
                ]) {
                    ForEach(viewModel.filteredEvents.lazy) { event in
                        NavigationLink(destination: EventInfoView(event: event)) {
                            EventsGridCellView(event: event)
                        }
                        .cornerRadius(15)
                    }
                }
            }
        }
    }
}
