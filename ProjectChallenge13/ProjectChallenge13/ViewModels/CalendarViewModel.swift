//
//  CalendarViewModel.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 19/05/26.
//

import Foundation


class CalendarViewModel {
    
    /// convert type date to string in format "yyyy-MM-dd"
    /// - Parameter date: receive a date
    /// - Returns: String with format "yyyy-MM-dd"
    func dateFormater(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    
    /// Calculate porcentage about current date and all dates
    /// - Parameters:
    ///   - day: current date
    ///   - dates: array saved date
    /// - Returns: double between 0 and 1
    func opacity(for day: Date, dates: [String]) -> Double{
        var countDay: Double = 0
        for i in dates{
            if i == dateFormater(date:day){
                countDay += 1
            }
        }
        return countDay/Double(dates.count)
    }

}
