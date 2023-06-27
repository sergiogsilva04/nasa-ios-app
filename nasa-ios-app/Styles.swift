import SwiftUI


struct PrimaryButtonStyle: ButtonStyle {
    var icon: Image?

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if let icon = icon {
                icon
            }
            
            configuration.label
        }
        .padding()
        .font(.headline)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(25)
        .shadow(radius: 5)
        .padding()
    }
}

struct MenuButtonStyle: ButtonStyle {
    var iconName: String
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(iconName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
            
            configuration.label
                .font(.system(size: 20))
        }
        .padding()
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(50)
        .shadow(radius: 5)
        .padding()
        .multilineTextAlignment(.center)
    }
}

struct EventFilterButtonStyle: ButtonStyle {
    var active: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 10)
            .font(.headline)
            .foregroundColor(.white)
            .background(active ? Color.cyan : Color.blue)
            .cornerRadius(50)
    }
}
