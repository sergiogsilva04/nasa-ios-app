import SwiftUI
import WebKit

struct Video: UIViewRepresentable {
    let videoUrl: String
    
    func makeUIView(context: Context) -> WKWebView {
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

struct ApodView: View {
    @StateObject var viewModel = ApodViewModel()

    var body: some View {
        VStack {
            Text("Astronomy Picture of the Day")
                .font(.system(size: 35))
                .multilineTextAlignment(.center)
            
            if (Common.checkInternetAvailability()) {
                Spacer()
                
                LoadingView(isShowing: .constant(viewModel.isShowingLoadingDialog)) {
                    VStack {
                        if let apod = viewModel.apod {
                            Spacer()
                            
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
                                
                                switch (viewModel.currentMediaType) {
                                    case .image:
                                        AsyncImage(url: URL(string: viewModel.currentAsyncImageUrl)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(15)
                                                
                                            } else if phase.error != nil {
                                                Text("No image loaded")
                                                
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                        .frame(width: 300, height: 300)
                                        
                                    case .video:
                                        Video(videoUrl: apod.url)
                                            .frame(width: 300, height: 300)
                                            .cornerRadius(15)

                                    
                                    default:
                                        Text("No media available")
                                            .padding()
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
                
                Button("Retry") {
                    print("checked internet")
                    viewModel.getData()
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
        .padding(10)
    }
}

struct ApodView_Previews: PreviewProvider {
    static var previews: some View {
        ApodView()
    }
}
