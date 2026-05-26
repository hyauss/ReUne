//
//  ProjectChallenge13Tests.swift
//  ProjectChallenge13Tests
//
//  Created by Vinicius Marques on 14/05/26.
//

import Testing
@testable import ProjectChallenge13
import Foundation

struct ProjectChallenge13Tests {
    
    let vm = CalendarViewModel()
    let mockDates: [Date] = [
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 10, hour: 20, minute: 30))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 20, minute: 30))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 20, minute: 30))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 21, minute: 30))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 22, hour: 21, minute: 30))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 22, hour: 21, minute: 30))!,
        Date(),
        Date(),
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 20, hour: 21, minute: 30))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 20, hour: 21, minute: 30))!
    ]

    @Test func opacityCheckTrue() {
        let result = vm.opacity(for: Date(), dates: mockDates)
        let expect = 0.2
        #expect(result==expect)
    }
    
    @Test func hourFormaterCheckTrue() {
        let result = vm.hourFormater(date: mockDates[0])
        let expect = "20"
        #expect(result==expect)
    }
    
    @Test func filterDateCheckTrue() {
        let result = vm.filterDate(dates: mockDates, day: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 10, hour: 20, minute: 30))!.formattedDate)
        let expect = [Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 10, hour: 20, minute: 30))]
        #expect(result==expect)
    }
    
    @Test func filterHourCheckTrue() {
        let result = vm.filterHour(dates: mockDates, day: mockDates[0].formattedDate, hour: mockDates[0])
        let expect = [Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 10, hour: 20, minute: 30))]
        #expect(result==expect)
    }
    
    @Test func mostFrequencyDateCheckTrue() {
        let result = vm.mostFrequencyDate(dates: mockDates)
        let expect = Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 20, minute: 30))?.formattedDate
        #expect(result==expect)
    }
    
    @Test func secondFrequencyDateCheckTrue() {
        let result = vm.secondFrequencyDate(dates: mockDates)
        let expect = mockDates[9].formattedDate
        #expect(result==expect)
    }
    
    @Test func opacityForHourCheckTrue() {
        let result = vm.opacityForHour(dates: mockDates, day: mockDates[0].formattedDate, hour: mockDates[0])
        let expect = 0.2
        #expect(result==expect)
    }

}
