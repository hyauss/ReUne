//
//  FormViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 25/05/26.
//

import Foundation

@Observable
class FormViewModel {
    let formModel = FormModel()
    var activities: [ActivitiesListModel] = []
    var selectedActivities: Set<ActivitiesModel> = []
    
    var dateList: [Date] = []
    
    init() {
        self.activities = formModel.meetingActivities
    }
    
    func filterActivities(categories: [CategoryModel]) -> [ActivitiesListModel] {
        activities.filter { activity in
            categories.contains(activity.category)
        }
    }
    
}
