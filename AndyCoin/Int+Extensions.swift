//
//  Int+Extensions.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/26/20.
//

import Foundation

extension Int {
    var andyCoinFormatted: String {
        return self >= 0 ? "Å\(self)" : "-Å\(abs(self))"
    }
}
