//
//  Date.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 19/7/22.
//

import Foundation

extension Date {
    static func getFixedDate(date: Date) -> Date {
//        let testDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
//        print("the data: \(testDate)")
        
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: -4, to: date)!
//        print(modifiedDate)
        
        return modifiedDate
    }
}
