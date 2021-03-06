//
//  State.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 10/25/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import SwiftUI

typealias Register = Int

struct ProgramState {
    var programCounter: Int = 0
    var inbox: Int? = nil
    var outbox: [Int] = []
    var accumulator: Int = 0
    var registers: [Register] = [Register](repeating: 000, count: 100)
    var printStatement: LocalizedStringKey = "initPrintStatement"
    var registersCurrentlyBeingEvaluated: [Register : Bool] = [Register : Bool]()
}
