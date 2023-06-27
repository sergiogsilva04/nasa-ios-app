import SwiftUI

struct EpicView: View {
    @StateObject var viewModel = EpicViewModel()
    

    var body: some View {
        VStack{
            Text("Earth Rotation").pageTitleTextStyle()
           
            HStack {
                Spacer().frame(width: 100)
                
                DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
                    .onChange(of: viewModel.currentDate) { _ in
                        viewModel.getData()
                    }
                
                Spacer().frame(width: 100)
            }
            
            Spacer()
            
            HStack{
                Button {
                    viewModel.getPreviousImageIndex()
                    print(viewModel.epic![viewModel.currentImageIndex])
                    
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                if let epic = viewModel.epic {
                    if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.dataFormatada2())/png/\(epic[viewModel.currentImageIndex].image).png") {
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
                        
                        Button {
                            viewModel.getNextImageIndex()
                            print(viewModel.epic![viewModel.currentImageIndex])
                            
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        
                    }
                }
            }
            
            
            Spacer()
            
            HStack{
                VStack{
                    if let epic = viewModel.epic {
                        if viewModel.previousImageIndex >= 0 && viewModel.previousImageIndex < epic.count {
                            let imageURLString = "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.dataFormatada2())/png/\(epic[viewModel.previousImageIndex].image).png"
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
                        if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.dataFormatada2())/png/\(epic[viewModel.currentImageIndex].image).png") {
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
                        if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/\(viewModel.currentDate.dataFormatada2())/png/\(viewModel.epic![viewModel.nextImageIndex].image).png") {
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
                Button {
                    if viewModel.isPlaying == false {
                        viewModel.startAutoPlay()
                    } else {
                        viewModel.stopAutoPlay()
                    }
                } label: {
                    Text(viewModel.isPlaying ? "Stop" : "Play")
                        .padding()
                        .frame(width: 150)
                        .background(viewModel.isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding(.top, 20)
                }
                
                
                Spacer()
                
                Button {
                    viewModel.getRandomImages()
                    
                } label: {
                    Text("Random Date")
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding(.top, 20)
                }
                Spacer()
            }
            
            
            
              

        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
        
    }
  }
    
struct EpicViewPreviews: PreviewProvider {
    static var previews: some View {
        EpicView()
    }
}


