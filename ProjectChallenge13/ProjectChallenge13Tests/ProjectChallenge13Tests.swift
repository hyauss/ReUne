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
        let actualDate = vm.dateFormater(date: Date())
        let date: String = Date().formattedDate
        
        let result = vm.opacity(for: Date(), dates: [actualDate, actualDate, "2026-05-19","2026-05-20"])
        let expect = 0.75
        #expect(result==expect)
    }

}
