import SwiftUI

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
                                Button {
                                    if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.currentDate) {
                                        viewModel.currentDate = previousDay
                                    }
                                    
                                } label: {
                                    Image(systemName: "chevron.left")
                                }
                                .disabled(viewModel.isPreviousDayAvailable())
                                
                                switch (viewModel.currentMediaType) {
                                    case .image:
                                        AsyncImage(url: URL(string: viewModel.currentAsyncImageUrl)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .cornerRadius(15)
                                                    .scaledToFit()
                                                    .frame(width: 300, height: 300)
                                                
                                            } else if phase.error != nil {
                                                Text("No image available")
                                                
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

                                Button {
                                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.currentDate) {
                                        viewModel.currentDate = nextDay
                                    }
                                    
                                } label: {
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
                            .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: "shuffle")))
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
