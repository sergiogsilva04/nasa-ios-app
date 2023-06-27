import MapKit
import SwiftUI


class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var locations = [Location]()
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @Published var city: String?
    @Published var country: String?
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("show an alert letting them know this is off and go turn them on.")
        }
    }
    
    func checkLocationAuthorization(){
        guard let locationManager = locationManager else{ return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("your location is restricted ikely due to parental control")
        case .denied:
            print("you have denied this app location permition go to settings to change it")
        case .authorizedAlways, .authorizedWhenInUse:
            mapRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func getRandomLocation() {
            let latitudeDelta: CLLocationDegrees = 0.5
            let longitudeDelta: CLLocationDegrees = 0.5
            
            let randomLatitude = Double.random(in: mapRegion.center.latitude - latitudeDelta...mapRegion.center.latitude + latitudeDelta)
            let randomLongitude = Double.random(in: mapRegion.center.longitude - longitudeDelta...mapRegion.center.longitude + longitudeDelta)
            LocationData.shared.longitude = randomLongitude
            LocationData.shared.latitude = randomLatitude
        }
    
    func getCityAndCountryFromCoordinates(completion: @escaping (String?, String?) -> Void) {
        let location = CLLocation(latitude: LocationData.shared.latitude, longitude: LocationData.shared.longitude)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding failed with error: \(error.localizedDescription)")
                    completion(nil, nil)
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("No placemark found")
                    completion(nil, nil)
                    return
                }
                
                var city: String?
                var country: String?
                
                if let locality = placemark.locality {
                    city = locality
                }
                
                if let countryName = placemark.country {
                    country = countryName
                }
                
                completion(country, city)
            }
        }
}


