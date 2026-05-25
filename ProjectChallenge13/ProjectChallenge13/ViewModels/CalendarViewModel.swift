//
//  CalendarViewModel.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 19/05/26.
//

import Foundation


class CalendarViewModel {
    
    /// convert type date to string in format "HH"
    /// - Parameter date: receive a date
    /// - Returns: String with format "HH"
    func hourFormater(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = .current
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    
    /// Calculate porcentage about current date and all dates
    /// - Parameters:
    ///   - day: current date
    ///   - dates: array saved date
    /// - Returns: double between 0 and 1
    func opacity(for day: Date, dates: [Date]) -> Double{
        var countDay: Double = 0
        for i in dates{
            if i.formattedDate == day.formattedDate{
                countDay += 1
            }
        }
        return countDay/Double(dates.count)
    }
    
    func opacityForHour(dates: [Date], day: Date, hour: Date) -> Double{
        
        let hourFilted = filterHour(dates: dates, day: day, hour: hour)
        
        return Double(hourFilted.count)/Double(dates.count) + 0.1
    }
    
    func mostFrequencyDate (dates: [Date]) -> Date{
        var counts: [Date: Int] = [:]
        
        for item in dates {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let newArray = counts.sorted { $0.value > $1.value }.map { $0.key }
        
        return newArray[0]
    }
    
    func secondFrequencyDate (dates: [Date]) -> Date{
        var counts: [Date: Int] = [:]
        
        for item in dates {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let newArray = counts.sorted { $0.value > $1.value }.map { $0.key }
        
        if newArray.count >= 2 {
            return newArray[1]
        }
        else{
            return newArray[0]
        }
    }
    
    func filterDate(dates: [Date], day: Date) -> [Date]{
        dates.filter { date in
            date.formattedDate.contains(day.formattedDate)
        }
    }

    func filterHour(dates: [Date], day: Date, hour: Date) -> [Date] {
        dates.filter { date in
            date.formattedDate.contains(day.formattedDate) &&
            hourFormater(date: date) == hourFormater(date: hour)
        }
    }
    
}
