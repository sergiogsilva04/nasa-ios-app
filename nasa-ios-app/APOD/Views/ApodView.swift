import SwiftUI

/// A view that displays the Astronomy Picture of the Day.
struct ApodView: View {
    @StateObject var viewModel = ApodViewModel()

    var body: some View {
        VStack {
            Text("Astronomy Picture of the Day")
                .pageTitleTextStyle()
            
            if (Common.checkInternetAvailability()) {
                Spacer()
                
                LoadingDialogView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        if let apod = viewModel.apod {
                            ApodContentView(viewModel: viewModel, apod: apod)
                        }
                    }
                    .padding(15)
                }
                
                Spacer()
                
            } else {
                NoInternetConnectionView {
                    viewModel.getData()
                }
            }
        }
        .padding(10)
    }
}

/// A preview provider for ApodView.
struct ApodView_Previews: PreviewProvider {
    static var previews: some View {
        ApodView()
    }
}
