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
    var lunches = Dynamic([Lunch]())
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
    
    func getAcceptedLunches() {
        apiManager.getAcceptedLunches(id: "id3") { [weak self] result in
            switch result {
            case .success(let lunches):
                self?.lunches.value = lunches
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isAcceptedLunch(slot: Timeslot, date: Date) -> Lunch? {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "yyyy-MM-dd")
        let date = dateFormatter.string(from: date)
        for lunch in lunches.value {
            if lunch.timeslot.id == slot.id && lunch.accepted == true && lunch.lunchDate == date {
                return lunch
            }
        }
        return nil
    }
    
    func getCollegueName(lunch: Lunch?) -> String? {
        if lunch?.master.id != "id3" {
            return lunch?.master.name
        } else {
            return lunch?.invitee.name
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
        let dayFormatter = DateFormatter.makeFormatter(dateFormat: "MMMM")
        
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
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "yyyy-MM-dd")
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
    
    func makeTime(from str: String) -> String? {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "HH:mm:ss")
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "HH:mm"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
