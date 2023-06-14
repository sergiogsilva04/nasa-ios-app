import SwiftUI
import MapKit

struct EventInfoView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var city: String?
    @State var country: String?
    
    var event: Event
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(event.categories.first!.id)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                    Text(event.categories.first!.title)
                        .font(.system(size: 20))
                }
                .padding(20)
                .background(event.closed == nil ? .green : .red)
                .cornerRadius(20)
                
                MapView(geometries: event.geometry, categoryId: event.categories.first!.id)
                
                Text("Start date")
                    .bold()
        
                Text("12 Jun 2023 | 15:15:20")
                
                Spacer()
                    .frame(height: 10)
                
                Text("End date")
                    .bold()
                
                Text(event.closed ?? "Not ended")
                
                Spacer()
                    .frame(height: 10)
                                
                Text("Location")
                    .bold()
 
                if let country = country {
                    Text("\(city != nil ? "\(country), \(city ?? "")" : country)")
  
                } else {
                   Text("Not available")
                       .onAppear {
                           getCityAndCountryFromCoordinates(coordinates: event.geometry.first!.coordinates) { (country, city) in
                               self.city = city
                               self.country = country
                           }
                       }
               }
            }
            .navigationTitle(event.title)
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

func getCityAndCountryFromCoordinates(coordinates: [Double], completion: @escaping (String?, String?) -> Void) {
    let location = CLLocation(latitude: coordinates.first!, longitude: coordinates.last!)
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
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.1, longitudeDelta: (maxLon - minLon) * 1.1)
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
                    annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    
                } else {
                    annotationView?.annotation = annotation
                }

                if let customAnnotation = annotation as? CustomAnnotation {
                    annotationView?.image = UIImage(named: customAnnotation.categoryId)
                }

                return annotationView
            }
    }
    
    class CustomAnnotation: MKPointAnnotation {
        var categoryId: String = ""
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: Event(id: "EONET_6363", title: "Tropical Storm Arlene", description: nil, link: "https://eonet.gsfc.nasa.gov/api/v3/events/EONET_6363", closed: nil, categories: [EventCategory(id: "severeStorms", title: "Severe Storms")], sources: [Source(id: "NOAA_NHC", url: "https://www.nhc.noaa.gov/text/refresh/MIATCPAT2+shtml/022035.shtml")], geometry: [Geometry(magnitudeValue: 35.0, magnitudeUnit: "kts", date: "2023-06-03T03:00:00Z", type: "Point", coordinates: [-85.5, 25.4])]))
    }
}
