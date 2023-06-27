import SwiftUI

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

struct ApodView_Previews: PreviewProvider {
    static var previews: some View {
        ApodView()
    }
}
