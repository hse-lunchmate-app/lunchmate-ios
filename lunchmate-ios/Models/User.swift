//
//  User.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import Foundation

struct User: Codable {
    let id: String
    var login: String
    var name: String
    var messenger: String
    var tastes: String
    var aboutMe: String
    var password: String
    var office: Office
    var image: URL?
}

extension User {
    static var users = [
        User(id: "0", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jssКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jssКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jssКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jКотлетка с пюрешкой и с огурчиком обязательно чтобы все по красоте было! ввлв вллв влвлв лвв влв влвьвьлв вов воs snshsjsj s js jsjjsjs jss", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "1", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "2", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "3", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "4", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "5", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "6", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil),
        User(id: "7", login: "ivan12345", name: "Петр Иванов", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil)
    ]
    static var currentUser = User(id: "8", login: "ivan12345", name: "Иван Петров", messenger: "ivan-pro100klass", tastes: "Котлетка с пюрешкой", aboutMe: "Я обычный Иван", password: "1234", office: Office.offices[0], image: nil)
}
