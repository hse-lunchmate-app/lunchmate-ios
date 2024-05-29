//
//  SlotAdditionViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.05.2024.
//

import Foundation

class SlotAdditionViewModel {
    
    // MARK: - Properties
    
    var stringDate = Dynamic("")
    var start = Dynamic(Date())
    var end = Dynamic(Date())
    var isReload = Dynamic(false)
    var isSwitchEnable = true
    var isAddition = true
    var apiManager = APIManager.shared
    var lunch: Lunch?
    var timeslot: Timeslot? = nil {
        willSet(timeslot) {
            let dateFormatter = DateFormatter.makeFormatter(dateFormat: "HH:mm:ss")
            start.value = dateFormatter.date(from: timeslot?.startTime ?? "13:00") ?? Date()
            end.value = dateFormatter.date(from: timeslot?.endTime ?? "14:00") ?? Date()
        }
    }
    var date: Date = Date() {
        willSet(newDate) {
            let dateFormatter = DateFormatter.makeFormatter(dateFormat: "EEEE, d MMM yyyy 'г.'")
            let str = dateFormatter.string(from: newDate)
            let firstLetterCapitalized = str.prefix(1).capitalized + str.dropFirst()
            stringDate.value = firstLetterCapitalized
        }
    }
    
    // MARK: - Methods
    
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
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "yyyy-MM-dd")
        let date: String? = dateFormatter.string(from: self.date)
        dateFormatter.dateFormat = "HH:mm:ss"
        let startTime = dateFormatter.string(from: startTime)
        let endTime = dateFormatter.string(from: endTime)
        return NetworkTimeslot(userId: "id3", date: date, startTime: startTime, endTime: endTime, permanent: isSwitchOn)
    }

}
