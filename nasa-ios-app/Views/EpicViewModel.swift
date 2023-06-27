import SwiftUI

class EpicViewModel: ObservableObject {
    @Published var epic: Epics? = nil
    @Published var currentImageIndex: Int = 0
    @Published var previousImageIndex: Int = 0
    @Published var nextImageIndex: Int = 1
    @Published var isPlaying = 1
    @Published var currentDate = Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 25))!
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDateComponents = DateComponents(year: 2013, month: 3, day: 1)
        let endDateComponents = DateComponents(year: 2021, month: 12, day: 25)
        
        return calendar.date(from: startDateComponents)!...calendar.date(from: endDateComponents)!
    }()
    
    init() {
        getData()
        
    }
    
    func getData() {
        Task{
            do {
                try await getPictures()
                previousImageIndex = epic!.count-1

            } catch {
                print(error)
            }
            
        }
    }
    func getPictures() async throws {
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://epic.gsfc.nasa.gov/api/natural/date/2015-10-31")!))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("Error loading post")
            print((response as? HTTPURLResponse)?.statusCode)
            return
        }

        self.epic = try JSONDecoder().decode(Epics.self, from: data)
        self.currentImageIndex = 0
    }
    
    
    
    func getNextImageIndex() {
        if currentImageIndex == epic!.count-1{
         currentImageIndex = 0
            previousImageIndex = epic!.count-1
            nextImageIndex = 1
        } else if currentImageIndex == 0 {
            currentImageIndex = 1
            previousImageIndex = 0
            nextImageIndex = 2
            
        }
        else {
            currentImageIndex+=1
            previousImageIndex+=1
            if nextImageIndex == epic!.count-1 {
                nextImageIndex = 0
            }else {
                nextImageIndex+=1
            }
            
        }
        
    }
    
    func getPreviousImageIndex() {
        if currentImageIndex == 0 {
         currentImageIndex = epic!.count-1
            previousImageIndex = epic!.count-2
            nextImageIndex = 0
        } else if currentImageIndex == epic!.count-1 {
            currentImageIndex = epic!.count-2
            previousImageIndex = epic!.count-3
            nextImageIndex = epic!.count-1
        }
        else {
            currentImageIndex-=1
            if previousImageIndex == 0 {
                previousImageIndex = epic!.count-1
            }else {
                previousImageIndex-=1
            }
            nextImageIndex-=1
        }
        
    }
    
    func autoPlay() {
        isPlaying = 1 // Assuming you have a variable named isPlaying
        
        func play() {
            getNextImageIndex()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if self.isPlaying == 1 {
                    play()
                }
            }
        }
        
        play()
    }
}

struct EpicViewModel_Previews: PreviewProvider {
    static var previews: some View {
        EpicView()
    }
}
