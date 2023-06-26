import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Spacer()
                    Text("Sou uma API da NASA onde é possivel ver imagens em satelite em varios dias e localizações diferentes, esperimenta para veres!!!")
                    Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 80)
                    
                    HStack {
                        Spacer().frame(width: 180)
                        NavigationLink(destination: MapView()) {
                                            Image("mapIcon")
                                                .resizable()
                                                .frame(width: 50, height: 40)
                                        }
                        
                        Spacer().frame(width: 50)
                        
                        DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
                        Spacer().frame(width: 100)
                    }
                    Spacer()
                    
                    if let post = viewModel.post {
                    if let url = URL(string: post.url) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 300)
                        }
                    }
                
                    Spacer()
                    
                    Button {
                        viewModel.post?.url = ""
                        viewModel.getData()
                        
                    } label: {
                        Text ("SEARCH")
                    }
                    
                    Spacer().frame(width: 350, height: 50)
                    
                    Button{
                        viewModel.post?.url = ""
                        Task {
                                do {
                                    try await viewModel.getRandomPost()
                                } catch {
                                    // Handle the error here
                                    print("Error: \(error)")
                                }
                            }
                    }label: {
                        Text ("RANDOM")
                    }
                    Spacer().frame(width: 350, height: 50)
                }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
