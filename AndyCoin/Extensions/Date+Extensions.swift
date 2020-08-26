//
//  Date+Extensions.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/26/20.
//

import Foundation

extension Date {
    func formatted(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: self)
    }
}
