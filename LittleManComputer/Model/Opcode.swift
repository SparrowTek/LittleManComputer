//
//  Opcode.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 10/25/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

enum Opcode: String {
    case add = "add"
    case subtract = "sub"
    case store = "sta"
    case load = "lda"
    case branch = "bra"
    case branchIfZero = "brz"
    case branchIfPositive = "brp"
    case input = "inp"
    case output = "out"
    case halt = "hlt"
    case data = "dat"
}
