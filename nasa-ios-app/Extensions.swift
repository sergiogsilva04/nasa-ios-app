import SwiftUI

extension Button {
    func filterButtonStyle(active: Bool) -> some View {
        self.padding(.all, 10)
            .font(.headline)
            .foregroundColor(.white)
            .background(active ? Color.cyan : Color.blue)
            .cornerRadius(50)
    }
}
