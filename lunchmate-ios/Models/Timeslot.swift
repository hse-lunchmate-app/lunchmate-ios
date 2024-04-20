//
//  Timeslot.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 15.04.2024.
//

import Foundation

struct Timeslot {
    let id: Int
    let weekDay: Int
    let date: String
    let startTime: String
    let endTime: String
    let permanent: Bool
    let collegue: User?
}

extension Timeslot {
    static var timeTable = [
        Timeslot(id: 1, weekDay: 3, date: "2024-04-16", startTime: "13:00", endTime: "14:00", permanent: true, collegue: nil),
        Timeslot(id: 2, weekDay: 3, date: "2024-04-16", startTime: "15:00", endTime: "16:15", permanent: false, collegue: User(id: "1", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil)),
        Timeslot(id: 2, weekDay: 3, date: "2024-04-16", startTime: "15:00", endTime: "16:15", permanent: false, collegue: User(id: "1", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil)),
        Timeslot(id: 3, weekDay: 6, date: "2024-04-26", startTime: "13:00", endTime: "14:00", permanent: true, collegue: nil),
        Timeslot(id: 4, weekDay: 5, date: "2024-04-17", startTime: "15:00", endTime: "16:15", permanent: false, collegue: User(id: "1", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil)),
    ]
}
