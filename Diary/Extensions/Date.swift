//
//  Date.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 24.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

extension Date {
    
    /**
     Formats date using the specified parameters
     
     - Parameters:
        - weekday: Bool
        - day: Bool
        - year: Bool
     
     - Returns: formatted date as a String
     */
    func getReadableWith(weekday: Bool, day: Bool, year: Bool) -> String {
        let locale = Locale(identifier: "en_US_POSIX")
        
        var readableDate: String = ""
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = locale
        
        let dateWeekday = calendar.weekdaySymbols[calendar.component(.weekday, from: self) - 1]
        let dateDay = calendar.component(.day, from: self)
        let dateMonth = calendar.monthSymbols[calendar.component(.month, from: self) - 1]
        let dateYear = calendar.component(.year, from: self)
        
        var ordinalIndicator = ""
        switch dateDay {
        case 1, 21, 31:
            ordinalIndicator = "st"
        case 2, 22:
            ordinalIndicator = "nd"
        case 3, 23:
            ordinalIndicator = "rd"
        default:
            ordinalIndicator = "th"
        }
        
        if  day && weekday && !year {
            readableDate = "\(dateWeekday) \(dateDay)\(ordinalIndicator) \(dateMonth)"
        } else if day && year && !weekday {
            readableDate = "\(dateMonth) \(dateDay)\(ordinalIndicator), \(dateYear)"
        } else if year && !day && !weekday {
            readableDate = "\(dateMonth) \(dateYear)"
        }
        
        return readableDate
    }
    
    /**
     Formats date into a MM/DD/YYYY format

     
     - Returns: formatted date as a String
     */
    func formatDate() -> String {
        
        var formatted: String = ""
        
        let calendar = Calendar(identifier: .gregorian)
        
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        
        formatted = "\(month)/\(day)/\(year)"
        
        return formatted
        
    }
    
}
