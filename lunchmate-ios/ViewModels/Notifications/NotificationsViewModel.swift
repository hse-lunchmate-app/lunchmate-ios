//
//  NotificationsViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import Foundation

class NotificationsViewModel {
    
    // MARK: - Properties
    
    let lunches = Dynamic([Lunch]())
    let apiManager = APIManager.shared
    var lunchesForCollectionView: [Lunch] = []
    
    // MARK: - Methods
    
    func getLunches() {
        apiManager.getAllLunches(id: "id1") { [weak self] result in
            switch result {
            case .success(let lunches):
                self?.lunches.value = lunches
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getNotificationsCount(index: Int) -> Int {
        let dateFormatter = DateFormatter.makeFormatter(dateFormat: "yyyy-MM-dd")
        if index == 0 {
            lunchesForCollectionView = lunches.value.filter({ $0.accepted == false && $0.invitee.id == "id1" })
            lunchesForCollectionView.sort(by: {dateFormatter.date(from: $0.lunchDate)! > dateFormatter.date(from: $1.lunchDate)!})
        } else {
            lunchesForCollectionView = lunches.value.filter({ $0.accepted == true })
            lunchesForCollectionView.sort(by: {dateFormatter.date(from: $0.lunchDate)! > dateFormatter.date(from: $1.lunchDate)!})
        }
        return lunchesForCollectionView.count
    }
    
    func getNotificationsCountForBadge() -> Int {
        return lunches.value.filter({ $0.accepted == false && $0.invitee.id == "id1" }).count
    }
    
}
