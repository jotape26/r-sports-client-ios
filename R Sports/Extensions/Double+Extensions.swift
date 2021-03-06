//
//  Double+Extensions.swift
//  R Sports
//
//  Created by João Leite on 28/05/19.
//  Copyright © 2019 João Pedro Leite. All rights reserved.
//

import Foundation

extension Double {
    func toCurrency() -> String {
        let form = NumberFormatter()
        form.numberStyle = .currency
        form.currencySymbol = "R$ "
        
        return "\(form.string(from: NSNumber(value: self)) ?? "")"
    }
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
