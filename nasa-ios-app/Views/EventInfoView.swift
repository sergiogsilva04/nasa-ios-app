import SwiftUI
import MapKit

struct EventInfoView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var event: Event
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("hurricane")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                    Text(event.categories.first!.title)
                        .font(.system(size: 20))
                }
                .padding(20)
                .background(event.closed == nil ? .green : .red)
                .cornerRadius(20)
                
                Map(coordinateRegion: $region)

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
                
                Text("Lisbon, Portugal")
            }
            .navigationTitle(event.title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: Event(id: "EONET_6363", title: "Tropical Storm Arlene", description: nil, link: "https://eonet.gsfc.nasa.gov/api/v3/events/EONET_6363", closed: nil, categories: [EventCategory(id: "severeStorms", title: "Severe Storms")], sources: [Source(id: "NOAA_NHC", url: "https://www.nhc.noaa.gov/text/refresh/MIATCPAT2+shtml/022035.shtml")], geometry: [Geometry(magnitudeValue: 35.0, magnitudeUnit: "kts", date: "2023-06-03T03:00:00Z", type: "Point", coordinates: [-85.5, 25.4])]))
    }
}
