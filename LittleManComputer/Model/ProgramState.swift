//
//  State.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 10/25/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import SwiftUI

typealias RegisterValue = Int

struct ProgramState {
    var programCounter: Int = 0
    var inbox: Int? = nil
    var outbox: [Int] = []
    var accumulator: Int = 0
    var registers: [Register] = [Register](repeating: Register(value: 0), count: 100)
    var printStatement: LocalizedStringKey = "initPrintStatement"
}

struct Register: Equatable {
    var value: RegisterValue?
    var display: String {
        get {
            guard let value = value else { return "" }
            let numValue = NSNumber(value: value)
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumIntegerDigits = 3
            return numberFormatter.string(from: numValue) ?? ""
        }
        set {
            guard let displayAsInt = Int(newValue) else {
                value = nil
                return
            }
            value = displayAsInt
        }
    }
}

extension Int {
    func asStringWith3IntegerDigits() -> String {
        let numValue = NSNumber(value: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 3
        return numberFormatter.string(from: numValue) ?? ""
    }
}
