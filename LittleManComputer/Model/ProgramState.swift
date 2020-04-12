//
//  State.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 10/25/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

typealias Register = Int

class ProgramState {
    var programCounter: Int = 0
    var inbox: Int? = nil
    var outbox: [Int] = []
    var accumulator: Int = 0
    var registers: [Register] = [Register](repeating: 000, count: 100)
    var printStatement: String = "initPrintStatement"
    
    init(registers: [Register]) {
        self.registers = registers
    }
}
