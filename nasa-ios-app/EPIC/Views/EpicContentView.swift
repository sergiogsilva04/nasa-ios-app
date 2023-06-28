import SwiftUI

struct EpicContentView: View {
    @ObservedObject var viewModel: EpicViewModel
       
    var body: some View {
        HStack {
            Spacer().frame(width: 100)
            
            VStack {
                DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
                    .onChange(of: viewModel.currentDate) { _ in
                        viewModel.getData()
                    }
                    .foregroundColor(viewModel.isPlaying ? .gray : .blue)
                    .disabled(viewModel.isPlaying)
                
                Text("\(viewModel.currentImageIndex + 1)/\(viewModel.epic?.count ?? 0)")
            }
            Spacer().frame(width: 100)
        }
        
        Spacer()
        
        HStack {
            Button {
                viewModel.getPreviousImageIndex()
                
            } label: {
                Image(systemName: "chevron.left")
            }
            .foregroundColor(viewModel.isPlaying ? .gray : .blue)
            .disabled(viewModel.isPlaying)
            
            if let epic = viewModel.epic {
                if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.format(format: "yyyy/MM/dd"))/png/\(epic[viewModel.currentImageIndex].image).png") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .cornerRadius(15)
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 300)
                }
            }
            
            Button {
                viewModel.getNextImageIndex()
                
            } label: {
                Image(systemName: "chevron.right")
            }
            .foregroundColor(viewModel.isPlaying ? .gray : .blue)
            .disabled(viewModel.isPlaying)
        }
        
        
        Spacer()
        
        HStack{
            VStack{
                if let epic = viewModel.epic {
                    if viewModel.previousImageIndex >= 0 && viewModel.previousImageIndex < epic.count {
                        let imageURLString = "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.format(format: "yyyy/MM/dd"))/png/\(epic[viewModel.previousImageIndex].image).png"
                        if let url = URL(string: imageURLString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .cornerRadius(15)
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
                
                Text("Previous")
                
            }
            
            Spacer().frame(width: 20)
            
            VStack{
                if let epic = viewModel.epic {
                    if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.format(format: "yyyy/MM/dd"))/png/\(epic[viewModel.currentImageIndex].image).png") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .cornerRadius(15)
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue, lineWidth: 3)
                                }
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                        .frame(width: 100, height: 100)
                    }
                }
                
                Text("Current")
            }
            Spacer().frame(width: 20)
            
            VStack{
                if let epic = viewModel.epic {
                    if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.format(format: "yyyy/MM/dd"))/png/\(epic[viewModel.nextImageIndex].image).png") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .cornerRadius(15)
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        
                    }
                }
                
                Text("Next")
            }
        }
        
        Spacer()
        
        HStack{
            Spacer()
            
            Button(viewModel.isPlaying ? "Stop" : "Play") {
                if viewModel.isPlaying == false {
                    viewModel.startAutoPlay()
                } else {
                    viewModel.stopAutoPlay()
                }
            }
            .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: viewModel.isPlaying ? "pause" : "play"), color: viewModel.isPlaying ? .red : .green))
            
            Spacer()
            
            Button("Random") {
                viewModel.getRandomImages()
            }
            .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: "shuffle"), color: viewModel.isPlaying ? .gray : .blue))
            .disabled(viewModel.isPlaying)
            
            Spacer()
        }
    }
}
