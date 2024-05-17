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
    var isReload = Dynamic(false)

    var lunch: Lunch?
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
    
    func getCollegueName() -> String? {
        if lunch?.master.id != "id3" {
            return lunch?.master.name
        } else {
            return lunch?.invitee.name
        }
    }
    
    func revokeLunch() {
        if let lunch = lunch {
            apiManager.revokeLunch(lunchId: lunch.id) { [weak self] error in
                if error == nil {
                    self?.isReload.value = true
                }
            }
        }
        isReload.value = false
    }
    
    func deleteSlot() {
        if let id = timeslot?.id {
            apiManager.deleteSlot(id: id) { [weak self] error in
                if error == nil {
                    self?.isReload.value = true
                }
            }
        }
        isReload.value = false
    }
    
    func postTimeSlot(timeslot: NetworkTimeslot) {
        apiManager.postNewSlot(slot: timeslot) { [weak self] error in
            if error == nil {
                self?.isReload.value = true
            }
        }
        isReload.value = false
    }
    
    func patchTimeSlot(timeslot: NetworkTimeslot) {
        if let id = self.timeslot?.id {
            apiManager.patchSlot(id: id, updatedSlot: timeslot) { [weak self] error in
                if error == nil {
                    self?.isReload.value = true
                }
            }
        }
        isReload.value = false
    }
    
    func makeNetworkTimeslot(isSwitchOn: Bool, startTime: Date, endTime: Date) -> NetworkTimeslot {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: String? = dateFormatter.string(from: self.date)
        let startTime = timeFormatter.string(from: startTime)
        let endTime = timeFormatter.string(from: endTime)
        return NetworkTimeslot(userId: "id3", date: date, startTime: startTime, endTime: endTime, permanent: isSwitchOn)
    }

}
