//
//  DateData.swift
//  SkidCare
//
//  Created by Aaliyah Lawrence on 11/16/23.
//

import UIKit

class DateData {
    
    public static let shared: DateData = DateData()
    
    private init(){
        
    }
    
    let datePicked: [DateComponents] = {
        
        var date: [DateComponents] = []
        
        date.append(DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 4, day: 21))
        return date
    }()
}
