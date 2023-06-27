import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var icon: Image?
    var color: Color?

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
        .background(color ?? .blue)
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
                .frame(width: 40, height: 40)
            
            configuration.label
                .font(.system(size: 20))
        }
        .padding()
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(50)
        .shadow(radius: 5)
        .padding(10)
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
            .background(active ? .cyan : .blue)
            .cornerRadius(50)
    }
}


struct PageTitleTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 35))
            .multilineTextAlignment(.center)
    }
}
