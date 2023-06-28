import SwiftUI

struct EarthView: View {
    @StateObject var viewModel = EarthViewModel()
    
    var body: some View {
        VStack {
            Text("Satellite Imagery")
                .pageTitleTextStyle()
            
            if (Common.checkInternetAvailability()) {
                Spacer()
                
                LoadingDialogView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        EarthContentView(viewModel: viewModel)
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

struct EarthView_Previews: PreviewProvider {
    static var previews: some View {
        EarthView()
    }
}
