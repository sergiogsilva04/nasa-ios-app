import SwiftUI

/// The main view of the application's home screen.
struct HomeView: View {
    /// An array of developers' information, including name and GitHub profile URL.
    let developers: [[String]] = [
        ["Miguel Rodrigues - 2022009", "https://github.com/Raydious"],
        ["João Fernandes - 2022062", "https://github.com/Johnnythejohnny"],
        ["Sérgio Silva - 2022284", "https://github.com/sergiogsilva04"]
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("{ NASA APIs }")
                    .font(.system(size: 35, weight: .bold))
                
                NavigationLink(destination: EventsView()) {
                    Text("Natural Event Tracker")
                }
                .buttonStyle(MenuButtonStyle(iconName: "eonet", color: .green))
                
                NavigationLink(destination: ApodView()) {
                    Text("Picture of the Day")
                }
                .buttonStyle(MenuButtonStyle(iconName: "apod", color: .black))
                
                NavigationLink(destination: EarthView()) {
                    Text("Satellite Imagery")
                }
                .buttonStyle(MenuButtonStyle(iconName: "earth", color: .gray))
                
                NavigationLink(destination: EpicView()) {
                    Text("Earth all Around")
                }
                .buttonStyle(MenuButtonStyle(iconName: "epic", color: .blue))

                // Section displaying a list of developers with links to their GitHub profiles
                Section {
                    List(developers, id: \.self) { developer in
                        if let url = URL(string: developer[1]) {
                            Link(destination: url) {
                                HStack {
                                    Image("github")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                
                                    Text(developer[0])
                                }
                            }
                            
                        } else {
                            Text(developer[0])
                        }
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

/// Preview provider for the HomeView.
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
