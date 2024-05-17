//
//  NotificationsViewModel.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import Foundation

class NotificationsViewModel {
    
    func getNotificationsCount() -> Int {
        return Notifications.notifications.count
    }
    
    
}
