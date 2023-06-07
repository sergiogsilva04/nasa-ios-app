//
//  ContentView.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 24/05/2023.
//

import SwiftUI
import UIKit

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct DatePickerWrapper: UIViewRepresentable {
    typealias UIViewType = UIDatePicker
    
    let datePicker: UIDatePicker
    
    func makeUIView(context: Context) -> UIDatePicker {
        return datePicker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        // Nenhuma atualização necessária neste exemplo
    }
}

struct ContentView: View {
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
            
            Text("When a date is select, the date that has been select will show a photograph from a rover on mars.")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            DatePickerWrapper(datePicker: datePicker)
                .frame(width: 300, height: 110)
                .multilineTextAlignment(.center)
                .padding(.top, 0)
            
            Spacer()
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


