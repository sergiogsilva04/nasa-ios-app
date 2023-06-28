import SwiftUI

/// A view that displays events in a list layout.
struct EventsListView: View {
    @StateObject var viewModel: EventsViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredEvents.lazy) { event in
                NavigationLink {
                    EventInfoView(event: event)

                } label: {
                   EventsListRowView(event: event)
                }
                .listRowBackground(event.closed == nil ? Color.green : Color.red)
            }
            .cornerRadius(15)
            .listStyle(.plain)
        }
    }
}
