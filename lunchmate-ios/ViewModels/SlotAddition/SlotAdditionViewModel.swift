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
    var apiManager = APIManager.shared
    
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
        dateFormatter.dateFormat = "HH:mm:ss"
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
    
    func makeNetworkTimeslot(isSwitchOn: Bool, startTime: Date, endTime: Date) -> NetworkTimeslot {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: String? = dateFormatter.string(from: self.date)
        let startTime = timeFormatter.string(from: startTime)
        let endTime = timeFormatter.string(from: endTime)
        return NetworkTimeslot(userId: "id3", date: date, startTime: startTime, endTime: endTime, permanent: isSwitchOn)
    }

}
