//
//  ScheduleViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import Foundation

class ScheduleViewModel {
    
    var selectedIndexPath: IndexPath? = IndexPath(row: 0, section: 0)
    
    func getDifferenceOfCurrentDayOfWeek() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        let currentDate = Date()
        let weekday = calendar.component(.weekday, from: currentDate)
        let daysFromMonday = (weekday + 5) % 7
        return daysFromMonday
    }
    
    func getDatesOfCurrentWeek() -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        let currentDate = Date()
        let weekday = calendar.component(.weekday, from: currentDate)
        let daysFromMonday = (weekday + 5) % 7
        let startDate = calendar.date(byAdding: .day, value: -daysFromMonday, to: currentDate)!
        var weekDays: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                weekDays.append(date)
            }
        }
        return weekDays
    }
}
