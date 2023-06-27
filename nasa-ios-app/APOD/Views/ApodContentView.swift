import SwiftUI

struct ApodContentView: View {
    @ObservedObject var viewModel: ApodViewModel
    let apod: Apod
       
    var body: some View {
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
                    YoutubeVideoView(videoUrl: apod.url)
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

struct ApodContentView_Previews: PreviewProvider {
    static var previews: some View {
        ApodContentView(viewModel: ApodView().viewModel, apod: Apod(date: "2023-01-01", explanation: "Explanation", media_type: "image", title: "Title", url: ""))
    }
}
