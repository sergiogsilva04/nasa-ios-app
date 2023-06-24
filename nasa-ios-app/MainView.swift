import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    EventsView()
                    
                } label: {
                    Text("Eventos")
                        .foregroundColor(.black)
                }
                
                NavigationLink {
                    ApodView()
                    
                } label: {
                    Text("APOD")
                        .foregroundColor(.black)
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
