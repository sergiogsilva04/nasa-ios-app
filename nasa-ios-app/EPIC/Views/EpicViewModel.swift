import SwiftUI

class EpicViewModel: ObservableObject {
    @Published var epic: Epics? = nil
    @Published var currentImageIndex: Int = 0
    @Published var previousImageIndex: Int = 0
    @Published var nextImageIndex: Int = 1
    @Published var isPlaying: Bool = false
    @Published var currentDate = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
    var autoPlayTimer: Timer?
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        let startDateComponents = DateComponents(year: 2015, month: 10, day: 31)
        let startDate = calendar.date(from: startDateComponents) ?? Date()
        
        return startDate...endDate
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
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://epic.gsfc.nasa.gov/api/natural/date/\(currentDate.dataFormatada())")!))
        print(currentDate.dataFormatada())
        
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
    
    
    
    
    func startAutoPlay() {
            guard isPlaying == false else { return }
            
            isPlaying = true
            autoPlayTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [weak self] _ in
                self?.getNextImageIndex()
            }
        }
        
    func stopAutoPlay() {
        isPlaying = false
        autoPlayTimer?.invalidate()
        autoPlayTimer = nil
    }
    
    func getRandomImages() {
        randomDateBetween(startDate: DateComponents(year: 2015, month: 10, day: 31), endDate: currentDate)
    }
    
    func randomDateBetween(startDate: DateComponents, endDate: Date) {
        // Check if the start date is later than the end date
        guard let startDate = Calendar.current.date(from: startDate),
              startDate < endDate else {
            return
        }
        
        // Get the start and end date's time intervals
        let startInterval = startDate.timeIntervalSince1970
        let endInterval = endDate.timeIntervalSince1970
        
        // Generate a random time interval within the range
        let randomInterval = TimeInterval.random(in: startInterval...endInterval)
        
        // Create a date using the random interval
        let randomDate = Date(timeIntervalSince1970: randomInterval)
        
        currentDate = randomDate
    }
}



struct EpicViewModel_Previews: PreviewProvider {
    static var previews: some View {
        EpicView()
    }
}
