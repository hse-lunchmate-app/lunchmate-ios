//
//  NetworkLunch.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 24.05.2024.
//

import Foundation

struct NetworkLunchForPatch: Codable {
    let masterId: String
    let inviteeId: String
    let timeslotId: Int
    let lunchDate: String
}
