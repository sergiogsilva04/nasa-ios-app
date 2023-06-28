import SwiftUI
import Network

/// A utility class that provides a method to check internet availability.
class Common {
    /// Checks if the device has an active internet connection.
    static func checkInternetAvailability() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)

        var isConnected = false

        // Handle path update events to determine network status
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        // Wait for the semaphore to be signaled
        semaphore.wait()

        return isConnected
    }
}

/// A view displayed when there is no internet connection.
struct NoInternetConnectionView: View {
    var retryAction: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundColor(.red)
            
            Text("No internet connection")
            
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(PrimaryButtonStyle(icon: Image(systemName: "arrow.clockwise")))
        }
    }
}

/// A `UIViewRepresentable` view that wraps `UIActivityIndicatorView` as SwiftUI view.
struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

/// A view that displays a loading dialog with an activity indicator.
struct LoadingDialogView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        ZStack {
            content()
                .disabled(isShowing)
                .blur(radius: isShowing ? 3 : 0)
            
            if (isShowing) {
                VStack {
                    Text("Loading...")
                        .font(.title2)
                    
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: 150, height: 150)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(25)
                .opacity(1)
                .shadow(radius: 15)
            }
        }
    }
}
