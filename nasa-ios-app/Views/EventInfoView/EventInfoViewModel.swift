import SwiftUI
import MapKit

class EventInfoViewModel: ObservableObject {
    @Published var event: Event
    @Published var city: String?
    @Published var country: String?
    
    let dateFormatter: DateFormatter
    
    init(event: Event) {
        self.event = event
        self.dateFormatter = DateFormatter()
    }
    
    var eventTitle: String {
        event.title
    }

    var eventCategoryId: String {
        event.categories.first?.id ?? ""
    }

    var eventCategoryTitle: String {
        event.categories.first?.title ?? ""
    }

    var eventGeometry: [Geometry] {
        event.geometry
    }

    var eventStartDate: String {
        getFormattedDate(date: event.geometry.first?.date ?? "")
    }

    var eventClosed: String? {
        if (event.closed != nil) {
            return getFormattedDate(date: event.closed!)
            
        } else {
            return event.closed
        }
    }
    
    func getFormattedDate(date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = dateFormatter.date(from: date) {
           //dateFormatter.dateFormat = "dd/MM/yyyy | HH:mm:ss"
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
           
            return dateFormatter.string(from: date)
        }

        return "Invalid date"
    }
    
    func getCityAndCountryFromCoordinates(coordinates: [Double], completion: @escaping (String?, String?) -> Void) {
        let location = CLLocation(latitude: coordinates.last!, longitude: coordinates.first!)
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
    
    struct MapView: UIViewRepresentable {
        let geometries: [Geometry]
        let categoryId: String

        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator
            addPins(for: geometries, mapView: mapView)
            setMapRegion(for: geometries, mapView: mapView)
            return mapView
        }

        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.removeAnnotations(uiView.annotations)
            addPins(for: geometries, mapView: uiView)
            setMapRegion(for: geometries, mapView: uiView)
        }

        func makeCoordinator() -> Coordinator {
            Coordinator()
        }

        private func addPins(for geometries: [Geometry], mapView: MKMapView) {
            for geometry in geometries {
                let annotation = CustomAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: geometry.coordinates.last!, longitude: geometry.coordinates.first!)
                annotation.categoryId = categoryId
                mapView.addAnnotation(annotation)
            }
        }

        private func setMapRegion(for geometries: [Geometry], mapView: MKMapView) {
            var minLat = Double.greatestFiniteMagnitude
            var maxLat = -Double.greatestFiniteMagnitude
            var minLon = Double.greatestFiniteMagnitude
            var maxLon = -Double.greatestFiniteMagnitude
            
            for geometry in geometries {
                let lat = geometry.coordinates.last!
                let lon = geometry.coordinates.first!
                
                minLat = min(minLat, lat)
                maxLat = max(maxLat, lat)
                minLon = min(minLon, lon)
                maxLon = max(maxLon, lon)
            }
            
            let centerLat = (minLat + maxLat) / 2
            let centerLon = (minLon + maxLon) / 2
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
            
            var span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5)
            
            if geometries.count <= 2 {
                span = MKCoordinateSpan(latitudeDelta: maxLat / minLat, longitudeDelta: maxLon / minLon)
            }
            
            let region = MKCoordinateRegion(center: center, span: span)
            
            mapView.setRegion(region, animated: true)
        }


        class Coordinator: NSObject, MKMapViewDelegate {
            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                    let reuseIdentifier = "customPin"
                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

                    if annotationView == nil {
                        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                        annotationView?.canShowCallout = true
                        
                    } else {
                        annotationView?.annotation = annotation
                    }

                    if let customAnnotation = annotation as? CustomAnnotation {
                        annotationView?.image = UIImage(named: customAnnotation.categoryId)
                    }
                
                    annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

                    return annotationView
                }
        }
        
        class CustomAnnotation: MKPointAnnotation {
            var categoryId: String = ""
        }
    }
}
