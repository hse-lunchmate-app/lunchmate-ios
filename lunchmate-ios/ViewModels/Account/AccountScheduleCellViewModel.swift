//
//  AccountScheduleCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 24.05.2024.
//

import Foundation

class AccountScheduleCellViewModel {
    var apiManager = APIManager.shared
    var userId = ""
    var newDateText = Dynamic("")
    var timeslots = Dynamic([Timeslot]())
    var currentDate: Date? = nil {
        willSet(timeslot) {
            if let date = timeslot {
                let str = dateFormatter.string(from: date)
                let firstLetterCapitalized = str.prefix(1).capitalized + str.dropFirst()
                newDateText.value = firstLetterCapitalized
            }
        }
    }
    
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEEE, d.MM"
        return dateFormatter
    }()
    
    var timeFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
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
    
    func makeDateStrings(start: String, end: String) -> (String, String) {
        let startDate = timeFormatter.date(from: start)
        let endDate = timeFormatter.date(from: end)
        timeFormatter.dateFormat = "HH:mm"
        let newStart = timeFormatter.string(from: startDate!)
        let newEnd = timeFormatter.string(from: endDate!)
        timeFormatter.dateFormat = "HH:mm:ss"
        return (newStart, newEnd)
    }
    
    func getStringDate() -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: currentDate!)
        dateFormatter.dateFormat = "EEEE, d.MM"
        return date
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
            }
        }
    }
}
