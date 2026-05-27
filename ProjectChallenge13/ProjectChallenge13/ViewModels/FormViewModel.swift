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
    
    func removeActivity(activity: ActivitiesModel) {
        self.selectedActivities.remove(activity)
    }
    
    func addCategory(activity: ActivitiesModel) {
        self.selectedActivities.insert(activity)
        print(selectedActivities)
    }
    
    func activityListModelToActivityModel(actv: [ActivitiesListModel]) -> [ActivitiesModel] {
        var newList: [ActivitiesModel] = []
        for i in actv {
            newList.append(ActivitiesModel(name: i.name, votos: 1))
        }
        return newList
    }
}
