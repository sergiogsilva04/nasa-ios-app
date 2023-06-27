import SwiftUI

struct EventInfoView: View {
    @ObservedObject var viewModel: EventInfoViewModel

    init(event: Event) {
        viewModel = EventInfoViewModel(event: event)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack {
                    Text(viewModel.eventTitle)
                        .font(.system(size: 30, weight: .bold))
                        .padding(.all, 10)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Image(viewModel.eventCategoryId)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                        
                        Text(viewModel.eventCategoryTitle)
                            .font(.system(size: 20))
                    }
                    .padding(15)
                    .background(viewModel.eventClosed == nil ? .green : .red)
                    .cornerRadius(50)
                }
                
                Spacer()

                EventInfoViewModel.MapView(geometries: viewModel.eventGeometry, categoryId: viewModel.eventCategoryId)
                    .padding(.vertical, 10)
                
                Spacer()

                VStack(alignment: .center) {
                    Text("Start at")
                        .bold()
                    
                    Text(viewModel.eventStartDate)
                }
                .padding(.bottom, 5)
                
                VStack(alignment: .center) {
                    Text("End at")
                        .bold()
                    
                    Text(viewModel.eventClosed ?? "Not ended")
                }
                .padding(.bottom, 5)
                
                VStack(alignment: .center) {
                    Text("Average magnitude")
                        .bold()
                    
                    if (viewModel.eventGeometry.first != nil && viewModel.eventGeometry.first!.magnitudeUnit != nil) {
                        Text("\(String(format: "%.1f", viewModel.averageMagnitude)) \(viewModel.magnitudeUnit)")
                        
                    } else {
                        Text("Not available")
                    }
                }
                .padding(.bottom, 5)
                
                VStack(alignment: .center) {
                    Text("Location")
                        .bold()
                    
                    if let country = viewModel.country {
                        Text("\(viewModel.city != nil ? "\(viewModel.city!), " : "")\(country)")
                        
                    } else {
                        Text("Not available")
                            .onAppear {
                                viewModel.getCityAndCountryFromCoordinates(coordinates: viewModel.eventGeometry.first?.coordinates ?? [0, 0]) { country, city in
                                    viewModel.city = city
                                    viewModel.country = country
                                }
                            }
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: Event(id: "EONET_6363", title: "Tropical Storm Alana", description: nil, link: "https://eonet.gsfc.nasa.gov/api/v3/events/EONET_6363", closed: nil, categories: [EventCategory(id: "severeStorms", title: "Severe Storms")], sources: [Source(id: "NOAA_NHC", url: "https://www.nhc.noaa.gov/text/refresh/MIATCPAT2+shtml/022035.shtml")], geometry: [Geometry(magnitudeValue: 35.0, magnitudeUnit: "kts", date: "2023-06-03T03:00:00Z", type: "Point", coordinates: [-85.5, 25.4])]))
    }
}
