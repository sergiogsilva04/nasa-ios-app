import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                EventsView()
                
            } label: {
                Text("Eventos")
                    .foregroundColor(.black)
            }
            
            NavigationLink {
                APODView()
                
            } label: {
                Text("APOD")
                    .foregroundColor(.black)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
