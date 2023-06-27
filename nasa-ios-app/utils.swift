//
//  utils.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 27/06/2023.
//

import Foundation

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
