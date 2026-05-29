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
    
    func opacityForHour(dates: [Date], day: String, hour: Date) -> Double{
        
        let hourFilted = filterHour(dates: dates, day: day, hour: hour)
        
        return Double(hourFilted.count)/Double(dates.count) + 0.1
    }
    
    func mostFrequencyDate (dates: [Date]) -> String{
        var counts: [String: Int] = [:]
        
        for item in dates {
//            let dayOnly = Calendar.current.startOfDay(for: item)
            
            counts[item.formattedDate] = (counts[item.formattedDate] ?? 0) + 1
        }
        
        let newArray = counts.sorted {
            
            if $0.value == $1.value {
                return $0.key < $1.key
            }
            return $0.value > $1.value
            
        }.map { $0.key }
        
        return  newArray[0]
    }
    
    func secondFrequencyDate (dates: [Date]) -> String{
        var counts: [String: Int] = [:]
        
        for item in dates {
            counts[item.formattedDate] = (counts[item.formattedDate] ?? 0) + 1
        }
        
        let newArray = counts.sorted {
            
            if $0.value == $1.value {
                return $0.key < $1.key
            }
            return $0.value > $1.value
            
        }.map { $0.key }
        
        if newArray.count >= 2 {
            return newArray[1]
        }
        else{
            return newArray[0]
        }
    }
    
    func filterDate(dates: [Date], day: String) -> [Date]{
        dates.filter { date in
            date.formattedDate.contains(day)
        }
    }

    func filterHour(dates: [Date], day: String, hour: Date) -> [Date] {
        dates.filter { date in
            date.formattedDate.contains(day) &&
            hourFormater(date: date) == hourFormater(date: hour)
        }
    }
    
    func dayNumber(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else { return "" }
        
        let day = Calendar.current.component(.day, from: date)
        return String(day)
    }
    
    func weekdayAbbreviation(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "pt_BR")
        
        guard let date = formatter.date(from: dateString) else { return "" }
        
        var week = Calendar.current
        week.locale = Locale(identifier: "pt_BR")
        let idx = week.component(.weekday, from: date) - 1
        
        return week.shortWeekdaySymbols[idx].replacingOccurrences(of: ".", with: "")
    }
}
