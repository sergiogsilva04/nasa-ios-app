import SwiftUI
import WebKit

struct Video: UIViewRepresentable {
    let videoUrl: String
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let youtubeURL = URL(string: videoUrl) else {
            return
        }
        
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}

struct APODView: View {
    @StateObject var viewModel = APODViewModel()
    @State var isLoading = true
    var body: some View {
        VStack{
            if (Common.checkInternetAvailability()) {
                Text("Astronomy Picture of the Day")
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                
                Spacer()

                LoadingView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        if let apod = viewModel.apod {
                            DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
                                .labelsHidden()
                            
                            HStack {
                                Button(action: {
                                    if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.currentDate) {
                                        viewModel.currentDate = previousDay
                                    }
                                }) {
                                    Image(systemName: "chevron.left")
                                }
                                .disabled(viewModel.isPreviousDayAvailable())
                                
                                if (viewModel.currentMediaType == "image") {
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
                                            .frame(width: 300, height: 300)
                                    }
                                    
                                } else if (viewModel.currentMediaType == "video") {
                                    if (isLoading) {
                                        ProgressView()
                                    }
                                    
                                    Video(videoUrl: apod.url)
                                        .frame(width: 300, height: 300)
                                        .cornerRadius(15)
                                }

                                Button(action: {
                                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.currentDate) {
                                        viewModel.currentDate = nextDay
                                    }
                                }) {
                                    Image(systemName: "chevron.right")
                                }
                                .disabled(viewModel.isNextDayAvailable())
                            }
                            .padding()
                                                        
                            Text(apod.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            
                            ScrollView {
                                Text(apod.explanation)
                            }
                            
                            Button("Random") {
                                viewModel.apod?.url = ""
                                viewModel.getData(random: true)
                            }
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                }
                
                Spacer()
                
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
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(10)
    }
}

struct APODView_Previews: PreviewProvider {
    static var previews: some View {
        APODView()
    }
}
