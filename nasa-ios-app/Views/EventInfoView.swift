import SwiftUI

struct EventInfoView: View {
    @StateObject var viewModel = ContentViewModel()
    var event: Event
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("hurricane")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                    Text(event.title)
                        .font(.system(size: 25))
                }
                .padding(20)
                .background(event.closed == nil ? .green : .red)
                .cornerRadius(20)
            
                Text("Category: \(event.categories.first!.title)")
                
                
                // TODO: MAP
                
                // TODO: Format the date
                //Text("Start date: \(viewModel.dateFormatter.date(from: "14/07/2020"))")
                Text("End date: \(event.closed ?? "Not finished")")
                
                // TODO: se valer a pena fazer uma field da ultima localizaçao do evento
            }
            .navigationTitle(event.title)
        }
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: Event(id: "EONET_6363", title: "Tropical Storm Arlene", description: nil, link: "https://eonet.gsfc.nasa.gov/api/v3/events/EONET_6363", closed: nil, categories: [EventCategory(id: "severeStorms", title: "Severe Storms")], sources: [Source(id: "NOAA_NHC", url: "https://www.nhc.noaa.gov/text/refresh/MIATCPAT2+shtml/022035.shtml")], geometry: [Geometry(magnitudeValue: 35.0, magnitudeUnit: "kts", date: "2023-06-03T03:00:00Z", type: "Point", coordinates: [-85.5, 25.4])]))
    }
}
