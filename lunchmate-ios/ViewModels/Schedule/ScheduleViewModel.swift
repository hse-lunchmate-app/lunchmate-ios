//
//  ScheduleViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import Foundation

class ScheduleViewModel {
    
    var changeWeek = 0
    
    let monthCases: [String: String] = [
        "января": "Январь",
        "февраля": "Февраль",
        "марта": "Март",
        "апреля": "Апрель",
        "мая": "Май",
        "июня": "Июнь",
        "июля": "Июль",
        "августа": "Август",
        "сентября": "Сентябрь",
        "октября": "Октябрь",
        "ноября": "Ноябрь",
        "декабря": "Декабрь"
    ]
    
    func updateChangeWeek(right: Bool) -> Bool {
        if right {
            if ((changeWeek + 7) / 7 == 4) {
                changeWeek += 7
                return false
            }
            changeWeek += 7
            return true
        } else {
            if changeWeek - 7 == 0 {
                changeWeek -= 7
                return false
            }
            changeWeek -= 7
            return true
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    func getDifferenceOfCurrentDayOfWeek() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        let currentDate = Date()
        let weekday = calendar.component(.weekday, from: currentDate)
        var daysFromMonday = (weekday + 5) % 7
        if daysFromMonday == 6 || daysFromMonday == 5 {
            daysFromMonday = 4
        }
        return daysFromMonday
    }
    
    func getMonths(dates: [Date]) -> [String] {
        var months: Set<String> = []
        let dayFormatter = DateFormatter()
        dayFormatter.timeZone = TimeZone(secondsFromGMT: 3*60*60)
        dayFormatter.locale = Locale(identifier: "ru_RU")
        dayFormatter.dateFormat = "MMMM"
        
        for date in dates {
            let monthString = dayFormatter.string(from: date)
            if let month = monthCases[monthString] {
                months.insert(month)
            }
        }
    
        return months.sorted(by: >)
    }
    
    func getInfoAboutMeetingsOfSelectedDay(selectedDay: IndexPath?) -> [Timeslot] {
        var index = selectedIndexPath?.row ?? getDifferenceOfCurrentDayOfWeek()
        if let selectedDay = selectedDay {
            index = selectedDay.row
        }
        let dates = getDatesOfCurrentWeek()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3*60*60)
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let date = dates[index]
        var listOfData: [Timeslot] = []
        for i in Timeslot.timeTable {
            if dateFormatter.string(from: date) == i.date {
                listOfData.append(i)
            }
        }
        return listOfData
    }
    
    func getDatesOfCurrentWeek() -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        let currentDate = Date()
        let weekday = calendar.component(.weekday, from: currentDate)
        let daysFromMonday = (weekday + 5) % 7
        let startDate = calendar.date(byAdding: .day, value: -daysFromMonday + changeWeek, to: currentDate)!
        var weekDays: [Date] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                weekDays.append(date)
            }
        }
        return weekDays
    }
}
