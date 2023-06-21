import MapKit
import SwiftUI



struct MapView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MapViewModel()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.mapRegion, showsUserLocation: true, annotationItems: viewModel.locations) { location in
                            MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                        }
                .ignoresSafeArea()
                .accentColor(Color(.systemPink))
                .onAppear{
                    viewModel.checkIfLocationServicesIsEnabled()
                }
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button {
                        let newLocation = Location(id: UUID(), latitude: viewModel.mapRegion.center.latitude, longitude: viewModel.mapRegion.center.longitude)
                        viewModel.locations.append(newLocation)
                        LocationData.shared.latitude = viewModel.mapRegion.center.latitude
                        LocationData.shared.longitude = viewModel.mapRegion.center.longitude
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
    }
    
    struct MapView_Previews: PreviewProvider {
        static var previews: some View {
            MapView()
        }
    }
}

