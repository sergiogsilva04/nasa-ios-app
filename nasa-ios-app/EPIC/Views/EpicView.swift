import SwiftUI

struct EpicView: View {
    @StateObject var viewModel = EpicViewModel()
    
    var body: some View {
        VStack {
            Text("Earth all Around").pageTitleTextStyle()
            
            if (Common.checkInternetAvailability()) {
                LoadingDialogView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        EpicContentView(viewModel: viewModel)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
                
            } else {
                NoInternetConnectionView(retryAction: viewModel.getData)
            }
        }
    }
}

struct EpicViewPreviews: PreviewProvider {
    static var previews: some View {
        EpicView()
    }
}
