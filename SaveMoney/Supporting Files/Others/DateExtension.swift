//
//  DateExtension.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 31/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import Foundation

extension Date {
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
}
