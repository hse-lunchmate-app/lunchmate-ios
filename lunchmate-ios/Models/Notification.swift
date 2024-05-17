//
//  Notification.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.05.2024.
//

import Foundation

struct Notifications {
    let collegue: User
    let accepted: Bool?
    let timeslot: Timeslot
}

extension Notifications {
    static var notifications = [
        Notifications(collegue: User.currentUser, accepted: nil, timeslot: Timeslot(id: 0, weekDay: 2, date: "2024-05-16", startTime: "13:00:00", endTime: "14:00:00", permanent: true)),
        Notifications(collegue: User.currentUser, accepted: true, timeslot: Timeslot(id: 0, weekDay: 2, date: "2024-05-16", startTime: "15:00:00", endTime: "16:00:00", permanent: true)),
        Notifications(collegue: User.currentUser, accepted: false, timeslot: Timeslot(id: 0, weekDay: 2, date: "2024-05-16", startTime: "19:00:00", endTime: "20:00:00", permanent: true)),
        Notifications(collegue: User.currentUser, accepted: true, timeslot: Timeslot(id: 0, weekDay: 2, date: "2024-05-17", startTime: "16:30:00", endTime: "20:00:00", permanent: true))
    ]
}
