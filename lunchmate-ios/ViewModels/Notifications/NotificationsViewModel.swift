//
//  NotificationsViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import Foundation

class NotificationsViewModel {
    
    let lunches = Dynamic([Lunch]())
    var lunchesForCollectionView: [Lunch] = []
    let apiManager = APIManager.shared
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        return df
    }()
    
    func getLunches() {
        apiManager.getAllLunches(id: "id3") { [weak self] result in
            switch result {
            case .success(let lunches):
                self?.lunches.value = lunches
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getNotificationsCount(index: Int) -> Int {
        if index == 0 {
            lunchesForCollectionView = lunches.value.filter({ $0.accepted == false && $0.invitee.id == "id3" })
            lunchesForCollectionView.sort(by: {dateFormatter.date(from: $0.lunchDate)! > dateFormatter.date(from: $1.lunchDate)!})
        } else {
            lunchesForCollectionView = lunches.value.filter({ $0.accepted == true })
            lunchesForCollectionView.sort(by: {dateFormatter.date(from: $0.lunchDate)! > dateFormatter.date(from: $1.lunchDate)!})
        }
        return lunchesForCollectionView.count
    }
    
    func getNotificationsCountForBadge() -> Int {
        return lunches.value.filter({ $0.accepted == false && $0.invitee.id == "id3" }).count
    }
    
}
