import SwiftUI

extension View {
    func pageTitleTextStyle() -> some View {
        modifier(PageTitleTextStyle())
    }
}

extension Date{
    func dataFormatada() -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
    func dataFormatada2() -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return dateFormatter.string(from: self)
    }
}

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        
        return self
            .resizable()
    }
}
