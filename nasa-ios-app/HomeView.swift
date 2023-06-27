import SwiftUI

struct HomeView: View {
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
