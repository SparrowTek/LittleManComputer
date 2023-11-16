//
//  Int.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/26/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation

extension Int {
    func toStringWith3IntegerDigits() -> String {
        let numValue = NSNumber(value: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 3
        return numberFormatter.string(from: numValue) ?? ""
    }
}
