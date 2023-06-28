import SwiftUI

/// A view that displays the content of the Astronomy Picture of the Day.
struct ApodContentView: View {
    @ObservedObject var viewModel: ApodViewModel
    let apod: Apod
       
    var body: some View {
        Spacer()
        
        // DatePicker for selecting the current date
        DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
            .labelsHidden()
        
        HStack {
            // Button for navigating to the previous day's APOD
            Button {
                if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.currentDate) {
                    viewModel.currentDate = previousDay
                }
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(viewModel.isPreviousDayAvailable())
            
            // Switch statement to display the APOD media based on the current media type
            switch (viewModel.currentMediaType) {
                case .image:
                    // AsyncImage for loading and displaying images from the currentAsyncImageUrl
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
                    // Display a YouTube video using the YoutubeVideoView with the APOD's URL
                    YoutubeVideoView(videoUrl: apod.url)
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                  
                default:
                    Text("No media available")
                        .padding()
            }
            
            // Button for navigating to the next day's APOD
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
                                    
        // Display the APOD's title
        Text(apod.title)
            .font(.headline)
            .multilineTextAlignment(.center)
        
        // Scrollable view to display the APOD's explanation
        ScrollView {
            Text(apod.explanation)
        }
        .frame(minHeight: 100)
        
        // Button for fetching a random APOD
        Button("Random") {
            viewModel.getData(random: true)
        }
        .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: "shuffle")))
    }
}

/// A preview provider for ApodContentView.
struct ApodContentView_Previews: PreviewProvider {
    static var previews: some View {
        ApodContentView(viewModel: ApodView().viewModel, apod: Apod(date: "2023-01-01", explanation: "Explanation", media_type: "image", title: "Title", url: ""))
    }
}
