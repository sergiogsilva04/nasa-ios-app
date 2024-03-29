import SwiftUI

struct EarthContentView: View {
    @ObservedObject var viewModel: EarthViewModel
    @StateObject var mapViewModel = MapViewModel()

    var body: some View {
        Spacer()
            .frame(height: 30)
        
        HStack {
            NavigationLink(destination: MapView()) {
                Image("mapIcon")
                    .resizable()
                    .frame(width: 50, height: 40)
            }
            
            DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
        }
        .padding()
        
        Spacer()
        
        //if let earth = viewModel.earth {
            if let url = URL(string: "https://api.nasa.gov/assets/img/general/houston_2.png") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .cornerRadius(15)
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 350, height: 350)
            }
        //}
        
        Spacer()
        
        VStack(alignment: .center) {
            Text("Location")
                .bold()
            
            if let country = mapViewModel.country {
                Text("\(mapViewModel.city != nil ? "\(mapViewModel.city!), " : "")\(country)")
                
            } else {
                Text("No location available")
                    .onAppear {
                        mapViewModel.getCityAndCountryFromCoordinates() { country, city in
                            mapViewModel.city = city
                            mapViewModel.country = country
                        }
                    }
            }
        }
        
        HStack {
            Button("Search") {
                viewModel.earth?.url = ""
                viewModel.getData()
                mapViewModel.getCityAndCountryFromCoordinates() { country, city in
                    mapViewModel.city = city
                    mapViewModel.country = country
                }
            }
            .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: "magnifyingglass"), color: .green))

            Button("Random") {
                viewModel.earth?.url = ""
                
                Task {
                    do {
                        try await viewModel.getRandomPost()
                        mapViewModel.getCityAndCountryFromCoordinates() { country, city in
                            mapViewModel.city = city
                            mapViewModel.country = country
                        }
                    } catch {
                        // Handle the error here
                        print("Error: \(error)")
                    }
                }
                
            }
            .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: "shuffle")))
        }
    }
}

struct EarthContentView_Previews: PreviewProvider {
    static var previews: some View {
        EarthContentView(viewModel: EarthView().viewModel)
    }
}
