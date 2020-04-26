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
    var value: RegisterValue
    var display: String {
        get {
            return "\(value)"
        }
        set {
            #warning("handle this guard with more than just a return")
            guard let displayAsInt = Int(newValue) else { return }
            value = displayAsInt
        }
    }
}
