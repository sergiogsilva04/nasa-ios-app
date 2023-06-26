import SwiftUI

struct MainView: View {
    let developers: [String] = ["Miguel Rodrigues - 2022987", "Joao Fernandes - 20222048", "Sérgio Silva - 2022284"]
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    EventsView()
                    
                } label: {
                    Image("eonet")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                    
                    Text("Natural Event Tracker")
                }
                .padding()
                .font(.system(size: 25))
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(50)
                .shadow(radius: 5)
                .padding()
                
                NavigationLink {
                    ApodView()
                    
                } label: {
                    Image("apod")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                    
                    Text("Astronomy Picture of the Day")
                }
                .padding()
                .font(.system(size: 25))
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(50)
                .shadow(radius: 5)
                .padding()
                
                Text("Developers")
                
                List(developers, id: \.self) { developer in
                    Text(developer)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
