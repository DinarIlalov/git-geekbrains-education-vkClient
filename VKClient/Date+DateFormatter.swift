//
//  Date+DateFormatter.swift
//  VKClient
//
//  Created by Илалов Динар on 16.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation

extension Date {
    func toRuDateString() -> String {
        let dateFormatter = DateFormatter.getStringRuFormatter()
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static func getStringRuFormatter() -> DateFormatter {
        let monthFormat = "MMM"
        let yearFormat = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd \(monthFormat)\(yearFormat)"
        return dateFormatter
    }
}
