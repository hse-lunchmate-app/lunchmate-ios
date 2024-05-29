//
//  NotificationsCollectionViewCellViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 25.05.2024.
//

import Foundation

class NotificationsCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    let apiManager = APIManager.shared
    var lunch: Lunch? = nil
    
    // MARK: - Methods
    
    func makeStringDay(lunchDate: String) -> String {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "yyyy-MM-dd")
        let date = dateFormatter.date(from: lunchDate)
        dateFormatter.dateFormat = "d MMM"
        let newDate = dateFormatter.string(from: date!)
        return newDate
    }
    
    func makeTime(time: String) -> String {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "HH:mm:ss")
        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "HH:mm"
        let newTime = dateFormatter.string(from: date!)
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
