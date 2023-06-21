//

import Foundation
import SwiftUI
import UIKit


struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemGreen
        return datePicker
    }()
    
    @State private var isRandomButtonClicked = false
    @State private var isSearchButtonClicked = false
    
    var body: some View {
        VStack{
            Text("Mars Images")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
            
            Spacer()
            
            Button(action:
                    {
                  isRandomButtonClicked.toggle()
                  // Lógica para lidar com o clique do botão "random"
                  // Implemente a lógica para exibir uma foto aleatória do rover em Marte.
                
              }) {
                      Text("Search")
                          .padding()
                          .background(Color.green)
                          .foregroundColor(.white)
                          .cornerRadius(50)
                          .padding(.top, 20)
                  }
            if let post = viewModel.posts {
                if let url = URL(string: post.first!.img_src) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 300)
                    
                }
            }
              Button(action:
                        {
                  isSearchButtonClicked.toggle()
                  // Lógica para lidar com o clique do botão "search"
                  // Implemente a lógica para pesquisar uma foto do rover em Marte com base na data selecionada.
              }) {
                  Text("Random")
                      .padding()
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(50)
                      .padding(.top, 20)
              }

        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
        
    }
    
   
  }
    
struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


