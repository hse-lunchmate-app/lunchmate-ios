//
//  AccountScheduleCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 24.05.2024.
//

import Foundation

class AccountScheduleCellViewModel {
    
    // MARK: - Properties
    
    var apiManager = APIManager.shared
    var userId = ""
    var newDateText = Dynamic("")
    var timeslots = Dynamic([Timeslot]())
    var currentDate: Date? = nil {
        willSet(timeslot) {
            if let date = timeslot {
                let dateFormatter = DateFormatter.makeFormatter(dateFormat: "EEEE, d.MM")
                let str = dateFormatter.string(from: date)
                let firstLetterCapitalized = str.prefix(1).capitalized + str.dropFirst()
                newDateText.value = firstLetterCapitalized
            }
        }
    }
    
    // MARK: - Methods
    
    func changeCurrentDate(direction: Bool?) -> Bool {
        var isSuccessfully = true
        switch direction {
        case true:
            if let date = currentDate {
                currentDate = date.addingTimeInterval(TimeInterval(60 * 60 * 24))
                if daysBetweenDates(date1: Date(), date2: currentDate!) == 6 {
                    isSuccessfully = false
                }
                getUserSchedule()
            }
        case false:
            if let date = currentDate {
                if daysBetweenDates(date1: Date(), date2: currentDate!) == 0 {
                    isSuccessfully = false
                }
                currentDate = date.addingTimeInterval(TimeInterval(-60 * 60 * 24))
                getUserSchedule()
            }
        default:
            currentDate = Date()
            getUserSchedule()
        }
        return isSuccessfully
    }
    
    func daysBetweenDates(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day ?? 0
    }
    
    func changeUserId(id: String) {
        userId = id
    }
    
    func makeDateString(from str: String) -> String {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "HH:mm:ss")
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date!)
    }
    
    func getStringDate() -> String {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "yyyy-MM-dd")
        return dateFormatter.string(from: currentDate!)
    }
    
    func getUserSchedule() {
        if userId != "" {
            let date = getStringDate()
            apiManager.getTimeTable(id: userId, date: date, free: true) { [weak self] result in
                switch result {
                case .success(let timeslot):
                    self?.timeslots.value = timeslot
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func postNewLunchInvite(timeslot: Timeslot, completion: @escaping (Error?) -> Void) {
        let date = getStringDate()
        let lunch = NetworkLunchForPatch(masterId: "id3", inviteeId: userId, timeslotId: timeslot.id, lunchDate: date)
        apiManager.postLunchInvite(lunch: lunch) { err in
            if let err = err as? NSError {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
}
