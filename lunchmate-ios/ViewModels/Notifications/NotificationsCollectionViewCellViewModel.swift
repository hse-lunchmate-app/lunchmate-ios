//
//  NotificationsCollectionViewCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 25.05.2024.
//

import Foundation

class NotificationsCollectionViewCellViewModel {
    
    var lunch: Lunch? = nil
    
    let apiManager = APIManager.shared
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        return df
    }()
    
    func makeStringDay(lunchDate: String) -> String {
        let date = dateFormatter.date(from: lunchDate)
        dateFormatter.dateFormat = "d MMM"
        let newDate = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return newDate
    }
    
    func makeTime(time: String) -> String {
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "HH:mm"
        let newTime = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return newTime
    }
    
    func acceptLunchInvite(completion: @escaping (Error?) -> Void) {
        if let lunch = lunch {
            apiManager.acceptLunch(lunchId: lunch.id) { error in
                if let error = error {
                    completion(error)
                }
                else {
                    completion(nil)
                }
            }
        }
    }
    
    func declineLunchInvite(completion: @escaping (Error?) -> Void) {
        if let lunch = lunch {
            apiManager.declineLunch(lunchId: lunch.id) { error in
                if let error = error {
                    completion(error)
                }
                else {
                    completion(nil)
                }
            }
        }
    }
}
