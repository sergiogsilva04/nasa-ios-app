import SwiftUI

/// A SwiftUI view for displaying natural events.
struct EventsView: View {
    /// The view model for managing the events data and state.
    @StateObject var viewModel = EventsViewModel()

    var body: some View {
        NavigationStack {
            Text("Natural Event Tracker")
                .pageTitleTextStyle()
            
            if (Common.checkInternetAvailability()) {
                /// Show the loading dialog if the internet is available.
                LoadingDialogView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        /// Display the event content view.
                        EventContentView(viewModel: viewModel)
                    }
                    .padding(15)
                }
            } else {
                /// Show the no internet connection view if the internet is not available.
                NoInternetConnectionView {
                    viewModel.getData()
                }
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
