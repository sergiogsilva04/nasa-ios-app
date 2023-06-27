import SwiftUI

struct HomeView: View {
    let developers: [String] = ["Miguel Rodrigues - 2022009", "João Fernandes - 2022062", "Sérgio Silva - 2022284"]
    
    var body: some View {
        NavigationStack {
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
                
                Section {
                    List(developers, id: \.self) { developer in
                        Text(developer)
                    }
                    .cornerRadius(20)
                    .scrollDisabled(true)
                    .padding(.horizontal, 32)
                    .frame(height: 200)
                    
                } header: {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.blue)
                        
                        Text("Developers")
                    }
                    .font(.system(size: 25, weight: .bold))
                    .padding()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
