import SwiftUI

extension View {
    /// A modifier to apply the page title text style to a view.
    func pageTitleTextStyle() -> some View {
        modifier(PageTitleTextStyle())
    }
}

extension Date {
    /// Formats the date into a string using the specified format.
    /// - Parameter format: The format string for the desired date representation.
    /// - Returns: A string representation of the date formatted according to the specified format.
    func format(format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    /// Converts the string into a `Date` object using the specified format.
    /// - Parameter format: The format string for parsing the date from the string.
    /// - Returns: A `Date` object parsed from the string using the specified format, or `nil` if the string cannot be parsed.
    func formatDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
}

extension Image {
    /// Loads the image data from the specified URL and creates a resizable `Image` view.
    /// - Parameter url: The URL of the image data.
    /// - Returns: A resizable `Image` view created from the image data at the specified URL.
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        
        return self
            .resizable()
    }
}
