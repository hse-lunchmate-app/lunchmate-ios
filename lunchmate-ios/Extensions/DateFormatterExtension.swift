//
//  DateFormatterExtension.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 29.05.2024.
//

import Foundation

extension DateFormatter {
    static func makeFormatter(dateFormat: String) -> DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = dateFormat
        df.timeZone = TimeZone(secondsFromGMT: 3 * 3600)!
        return df
    }
}
