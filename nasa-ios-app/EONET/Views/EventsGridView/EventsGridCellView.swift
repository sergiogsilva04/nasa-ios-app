import SwiftUI

struct EventsGridCellView: View {
    let event: Event
    
    var body: some View {
        VStack {
            Image(event.categories.first!.id)
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
            
            Text(event.title)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 150, height: 150)
        .padding(15)
        .background(event.closed == nil ? .green : .red)
    }
}

struct EventsGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        EventsGridCellView(event: Event(id: "EONET_6363", title: "Tropical Storm Arlene", description: nil, link: "https://eonet.gsfc.nasa.gov/api/v3/events/EONET_6363", closed: nil, categories: [EventCategory(id: "severeStorms", title: "Severe Storms")], sources: [Source(id: "NOAA_NHC", url: "https://www.nhc.noaa.gov/text/refresh/MIATCPAT2+shtml/022035.shtml")], geometry: [Geometry(magnitudeValue: 35.0, magnitudeUnit: "kts", date: "2023-06-03T03:00:00Z", type: "Point", coordinates: [-85.5, 25.4])]))
    }
}
