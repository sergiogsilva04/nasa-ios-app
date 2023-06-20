import SwiftUI

struct APODView: View {
    @StateObject var viewModel = APODViewModel()
    
    var body: some View {
        VStack() {
            if (Common.checkInternetAvailability()) {
                LoadingView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack() {
                        if let apod = viewModel.apod {
                            Text("Astronomy Picture of the Day")
                                .font(.system(size: 35))
                                .multilineTextAlignment(.center)

                            if let url = URL(string: apod.url) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 300, height: 300)
                                
                            } else {
                                Text("Invalid image URL")
                                    .padding()
                            }
                            
                            DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
                            
                            Text(apod.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(15)
                
            } else {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.red)
                
                Text("No internet connection")
                
                Button(action: {
                    print("checked internet")
                    viewModel.getData()
                    
                }) {
                    Text("Retry")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            viewModel.getData()
        }
    }
}

struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView()
    }
}
