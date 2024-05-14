//
//  SlotAdditionViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.05.2024.
//

import Foundation

class SlotAdditionViewModel {
    
    var stringDate = Dynamic("")
    var start = Dynamic(Date())
    var end = Dynamic(Date())
    var isSwitchEnable = true
    var isAddition = true
    
    var timeslot: Timeslot? = nil {
        willSet(timeslot) {
            start.value = timeFormatter.date(from: timeslot?.startTime ?? "13:00") ?? Date()
            end.value = timeFormatter.date(from: timeslot?.endTime ?? "14:00") ?? Date()
        }
    }
    
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEEE, d MMM yyyy 'г.'"
        return dateFormatter
    }()
    
    var timeFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    var date: Date = Date() {
        willSet(newDate) {
            let str = dateFormatter.string(from: newDate)
            let firstLetterCapitalized = str.prefix(1).capitalized + str.dropFirst()
            stringDate.value = firstLetterCapitalized
        }
    }
    
    func setDate(newDate: Date) {
        date = newDate
    }
    
    func calculateWeekDay() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        let weekday = calendar.component(.weekday, from: date)
        return (weekday + 5) % 7 + 1
    }
    
    func calculateId() -> Int {
        var nextID = 0
        for i in Timeslot.timeTable {
            if i.id > nextID {
                nextID = i.id
            }
        }
        return nextID + 1
    }
    
    func makeNewTimeslot(isSwitchOn: Bool, startTime: Date, endTime: Date, isCancel: Bool) -> Timeslot {
        if isCancel {
            if let slot = timeslot {
                return Timeslot(id: slot.id, weekDay: slot.weekDay, date: slot.date, startTime: slot.startTime, endTime: slot.endTime, permanent: slot.permanent, collegue: nil)
            }
        }
        var permanent = false
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date: String? = dateFormatter.string(from: self.date)
        if isSwitchOn {
            date = nil
            permanent = true
        }
        let startTime = timeFormatter.string(from: startTime)
        let endTime = timeFormatter.string(from: endTime)
        if let slot = timeslot {
            return Timeslot(id: slot.id, weekDay: slot.weekDay, date: date, startTime: startTime, endTime: endTime, permanent: permanent, collegue: slot.collegue)
        } else {
            let weekDay = calculateWeekDay()
            let id = calculateId()
            return Timeslot(id: id, weekDay: weekDay, date: date, startTime: startTime, endTime: endTime, permanent: permanent, collegue: nil)
        }
    }
    
}
