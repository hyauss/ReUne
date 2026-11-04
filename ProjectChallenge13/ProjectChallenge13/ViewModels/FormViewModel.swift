//
//  FormViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 25/05/26.
//

import Foundation

/// ViewModel that manages the form for creating a new event.
@Observable
class FormViewModel {
    /// The data source containing all available activities.
    let formModel = FormModel()
    /// All available activities loaded from ``FormModel``.
    var activities: [ActivitiesListModel] = []
    /// Activities selected by the user to be voted on.
    var selectedActivities: Set<ActivitiesModel> = []
    /// Dates selected by the user for the event.
    var dateList: [Date] = []
    
    init() {
        self.activities = formModel.meetingActivities
    }
    
    /// Returns activities that belong to the given categories.
    /// - Parameter categories: The categories to filter by.
    /// - Returns: A filtered list of activities.
    func filterActivities(categories: [CategoryModel]) -> [ActivitiesListModel] {
        activities.filter { activity in
            categories.contains(activity.category)
        }
    }
    
    /// Removes an activity from the selected activities.
    /// - Parameter activity: The activity to be removed.
    func removeActivity(activity: ActivitiesModel) {
        self.selectedActivities.remove(activity)
    }
    
    /// Adds an activity to the selected activities.
    /// - Parameter activity: The activity to be added.
    func addCategory(activity: ActivitiesModel) {
        self.selectedActivities.insert(activity)
    }
    
    /// Converts a list of ``ActivitiesListModel`` to ``ActivitiesModel``.
    /// - Parameter actv: The list to convert.
    /// - Returns: A list of ``ActivitiesModel`` with `votos` set to `1`.
    func activityListModelToActivityModel(actv: [ActivitiesListModel]) -> [ActivitiesModel] {
        var newList: [ActivitiesModel] = []
        for i in actv {
            newList.append(ActivitiesModel(name: i.name, votos: 1))
        }
        return newList
    }
}
