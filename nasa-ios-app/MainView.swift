import SwiftUI

struct MainView: View {
    let developers: [String] = ["Miguel Rodrigues - 2022009", "Joao Fernandes - 2022062", "Sérgio Silva - 2022284"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("{ NASA APIs }")
                    .font(.system(size: 35, weight: .bold))
                
                NavigationLink {
                    EventsView()
                    
                } label: {
                    Text("Natural Event Tracker")
                }
                .buttonStyle(MenuButtonStyle(iconName: "eonet", color: .green ))
                
                NavigationLink {
                    ApodView()
                    
                } label: {
                    Text("Astronomy Picture of the Day")

                }
                .buttonStyle(MenuButtonStyle(iconName: "apod", color: .black ))
                
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.blue)
                    
                    Text("Developers")
                }
                .font(.system(size: 25, weight: .bold))
                .padding()
                
                List(developers, id: \.self) { developer in
                    Text(developer)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listStyle(.plain)
                .scrollDisabled(true)
                .padding(.horizontal, 32)
                .frame(height: 150)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
