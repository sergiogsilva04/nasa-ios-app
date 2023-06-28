import SwiftUI
import MapKit

/// A view model for managing the event information and associated operations.
class EventInfoViewModel: ObservableObject {
    /// The event data.
    @Published var event: Event
    /// The city where the event occurred.
    @Published var city: String?
    /// The country where the event occurred.
    @Published var country: String?
    
    /// The date formatter for formatting dates.
    let dateFormatter: DateFormatter
    
    /// Initializes the event info view model with an event.
    /// - Parameter event: The event data.
    init(event: Event) {
        self.event = event
        self.dateFormatter = DateFormatter()
    }
    
    /// The title of the event.
    var eventTitle: String {
        event.title
    }

    /// The category ID of the event.
    var eventCategoryId: String {
        event.categories.first?.id ?? ""
    }

    /// The title of the event category.
    var eventCategoryTitle: String {
        event.categories.first?.title ?? ""
    }

    /// The geometries associated with the event.
    var eventGeometry: [Geometry] {
        event.geometry
    }

    /// The start date of the event formatted as a string.
    var eventStartDate: String {
        getFormattedDate(date: event.geometry.first?.date ?? "")
    }

    /// The closure date of the event formatted as a string, or `nil` if not available.
    var eventClosed: String? {
        if let closed = event.closed {
            return getFormattedDate(date: closed)
        } else {
            return event.closed
        }
    }
    
    /// The average magnitude of the event geometries.
    var averageMagnitude: Double {
        var sum: Double = 0
        
        eventGeometry.forEach { geometry in
            sum += geometry.magnitudeValue ?? 0
        }
        
        return sum / Double(eventGeometry.count)
    }
    
    /// The unit of measurement for the event magnitude.
    var magnitudeUnit: String {
        event.geometry.first?.magnitudeUnit ?? ""
    }
    
    /// Formats the given date string and returns it as a formatted string.
    /// - Parameter date: The date string to format.
    /// - Returns: The formatted date string.
    func getFormattedDate(date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
           
            return dateFormatter.string(from: date)
        }

        return "Invalid date"
    }
    
    /// Retrieves the city and country information from the given coordinates.
    /// - Parameters:
    ///   - coordinates: The coordinates (latitude and longitude) of the location.
    ///   - completion: A completion closure called with the retrieved city and country information.
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
    
    /// A `UIViewRepresentable` wrapper for displaying a map view with annotations.
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

        func addPins(for geometries: [Geometry], mapView: MKMapView) {
            for geometry in geometries {
                let annotation = CustomAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: geometry.coordinates.last!, longitude: geometry.coordinates.first!)
                annotation.categoryId = categoryId
                mapView.addAnnotation(annotation)
            }
        }

        func setMapRegion(for geometries: [Geometry], mapView: MKMapView) {
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
            
            if (geometries.count <= 2) {
                span = MKCoordinateSpan(latitudeDelta: maxLat / minLat, longitudeDelta: maxLon / minLon)
            }
            
            let region = MKCoordinateRegion(center: center, span: span)
            
            mapView.setRegion(region, animated: true)
        }


        class Coordinator: NSObject, MKMapViewDelegate {
            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                let reuseIdentifier = "customPin"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

                if (annotationView == nil) {
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
        
        /// A custom annotation for the map view.
        class CustomAnnotation: MKPointAnnotation {
            var categoryId: String = ""
        }
    }
}
