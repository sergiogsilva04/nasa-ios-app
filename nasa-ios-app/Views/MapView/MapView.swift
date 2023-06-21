//
//  MapView.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 07/06/2023.
//
import MapKit
import SwiftUI



struct MapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @StateObject private var viewModel = MapViewModel()
    @State private var locations = [Location]()
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.mapRegion, showsUserLocation: true, annotationItems: locations) { location in
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
                        locations.append(newLocation)
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

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12),
                                                  span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("show an alert letting them know this is off and go turn them on.")
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else{ return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("your location is restricted ikely due to parental control")
        case .denied:
            print("you have denied this app location permition go to settings to change it")
        case .authorizedAlways, .authorizedWhenInUse:
            mapRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                           span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

struct Location: Identifiable {
    var id: UUID
    let latitude: Double
    let longitude: Double
}
