

import Foundation
import SwiftUI
import UIKit


struct EpicView: View {
    @StateObject var viewModel = EpicViewModel()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemGreen
        return datePicker
    }()

    var body: some View {
        VStack{
            Text("Mars Images")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            
           
            Spacer().frame(height: 30)
            
            HStack{
                Spacer().frame(width: 100)
                
                DatePicker("", selection: $viewModel.currentDate, in: viewModel.dateRange, displayedComponents: .date)
                
                Spacer().frame(width: 100)
            }
            
            Spacer()
            
            HStack{
                Button {
                    viewModel.getPreviousImageIndex()
                    print(viewModel.epic![viewModel.currentImageIndex])
                    
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                
                if let epic = viewModel.epic {
                    if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/2015/10/31/png/\(viewModel.epic![viewModel.currentImageIndex].image).png") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .cornerRadius(15)
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 300)
                        
                        Button {
                            viewModel.getNextImageIndex()
                            print(viewModel.epic![viewModel.currentImageIndex])
                            
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        
                    }
                }
            }
            
            
            Spacer()
            
            HStack{
                VStack{
                    if let epic = viewModel.epic {
                        if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/2015/10/31/png/\(viewModel.epic![viewModel.previousImageIndex].image).png") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .cornerRadius(15)
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            
                        }
                    }
                    
                    Text("Previous")
                    
                }
                
                
                Spacer().frame(width: 20)
                VStack{
                    if let epic = viewModel.epic {
                        if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/2015/10/31/png/\(viewModel.epic![viewModel.currentImageIndex].image).png") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .cornerRadius(15)
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.blue, lineWidth: 3)
                                    }
                                
                            } placeholder: {
                                ProgressView()
                            }
                            
                            .frame(width: 100, height: 100)
                            
                            
                            
                            
                        }
                    }
                    
                    Text("Current")
                }
                
                
                
                Spacer().frame(width: 20)
                
                VStack{
                    if let epic = viewModel.epic {
                        if let url = URL(string: "https://epic.gsfc.nasa.gov/archive/natural/2015/10/31/png/\(viewModel.epic![viewModel.nextImageIndex].image).png") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .cornerRadius(15)
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            
                           
                        }
                    }
                    
                    Text("Next")
                }
            }
            
            Spacer()
            
            HStack{
                Spacer()
                Button {
                    viewModel.autoPlay()
                    
                } label: {
                    Text("Play")
                        .padding()
                        .frame(width: 150)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding(.top, 20)
                }
                
                
                Spacer()
                
                Button(action:
                          {
                }) {
                    Text("Random Date")
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding(.top, 20)
                }
                Spacer()
            }
            
            
            
              

        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
        
    }
  }
    
struct EpicViewPreviews: PreviewProvider {
    static var previews: some View {
        EpicView()
    }
}


