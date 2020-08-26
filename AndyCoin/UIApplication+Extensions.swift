//
//  UIApplication+Extensions.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/25/20.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
