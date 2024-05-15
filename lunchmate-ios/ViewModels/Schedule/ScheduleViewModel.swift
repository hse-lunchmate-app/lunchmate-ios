//
//  ScheduleViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import Foundation

class ScheduleViewModel {
    
    var changeWeek = 0
    var permanentSlots: [Timeslot?] = Array(repeating: nil, count: 7)
    var apiManager = APIManager.shared
    var timeTable = Dynamic([Timeslot]())
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
    
    var timeFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    func getAllPermanentSlots() {
        permanentSlots = Array(repeating: nil, count: 7)
        for i in timeTable.value {
            if i.permanent == true {
                permanentSlots[i.weekDay - 1] = i
            }
        }
    }
    
    func getTimeTable() {
        apiManager.getTimeTable(id: "id3") { [weak self] result in
            switch result {
            case .success(let timetable):
                self?.timeTable.value = timetable
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateChangeWeek(right: Bool) -> Bool {
        if right {
            changeWeek += ((changeWeek) / 7 == 4) ? 0 : 7
            return !((changeWeek) / 7 == 4)
        } else {
            changeWeek -= (changeWeek == 0) ? 0 : 7
            return !(changeWeek == 0)
        }
    }
    
    var selectedIndexPath: IndexPath?
    var selectedTimeslot: Timeslot?
    
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
        for i in timeTable.value {
            if let lunchDate = i.date {
                if dateFormatter.string(from: date) == lunchDate {
                    listOfData.append(i)
                }
            }
        }
        if let slot = permanentSlots[index] {
            listOfData.insert(slot, at: 0)
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
