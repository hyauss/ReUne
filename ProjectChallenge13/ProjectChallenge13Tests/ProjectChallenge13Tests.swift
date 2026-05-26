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
    
    

    @Test func opacityCheckTrue() {
        let vm = CalendarViewModel()
        let calendar = Calendar.current
        let mockDates: [Date] = [
            calendar.date(from: DateComponents(year: 2026, month: 5, day: 10))!,
            calendar.date(from: DateComponents(year: 2026, month: 5, day: 15))!,
            calendar.date(from: DateComponents(year: 2026, month: 5, day: 15))!,
            calendar.date(from: DateComponents(year: 2026, month: 5, day: 22))!,
            calendar.date(from: DateComponents(year: 2026, month: 5, day: 20))!
        ]
        
        let result = vm.opacity(for: Date(), dates: mockDates)
        let expect = 0.2
        #expect(result==expect)
    }

}
