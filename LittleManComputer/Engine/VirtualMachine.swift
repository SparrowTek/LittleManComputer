//
//  VirtualMachine.swift
//  LittleManComputer
//
//  Created by SparrowTek on 8/13/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine

struct State {
    var programCounter: Int = 0
    var inbox: Int? = nil
    var outbox: [Int] = []
    var accumulator: Int = 0
    var ram: RAM
}

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
    case data = "dat"
    case halt = "hlt"
}

//struct Register {
//    var value: Int
//}

typealias Register = Int

struct RAM {
    var registers: [Register]
}

struct Instruction {
    var opcode: Opcode
    var address: Int
}

struct Program {
    var sourceCode: String
//    var ram: RAM
}

//enum StateError: Error {
//    case generic
//}

class VirtualMachine {
    
    var state: CurrentValueSubject<State, /*StateError*/ Never>
    var input: Int? {
        didSet {
            state.value.inbox = input
        }
    }
    
    init(state: State) {
        self.state = CurrentValueSubject<State, Never>(state)
    }
    
    func step() {
        let ogState = state.value
        //    1 - Check the Program Counter for the mailbox number that contains a program instruction (i.e. zero at the start of the program)
        let register = state.value.ram.registers[state.value.programCounter]
        
        //    2 - Fetch the instruction from the mailbox with that number. Each instruction contains two fields: An opcode (indicating the operation to perform) and the address field (indicating where to find the data to perform the operation on).
        let instruction = getInstruction(for: register)
        
        //    3 - Increment the Program Counter (so that it contains the mailbox number of the next instruction)
        let programCounter = state.value.programCounter + 1
        
        //    4 - Decode the instruction. If the instruction utilises data stored in another mailbox then use the address field to find the mailbox number for the data it will work on, e.g. 'get data from mailbox 42')
        
        //    5 - Fetch the data (from the input, accumulator, or mailbox with the address determined in step 4)
        
        // if input needed { check for inbox to be non nil
        guard let inbox = state.value.inbox else {
            return
        }
        //    6 - Execute the instruction based on the opcode given
        //    7 - Branch or store the result (in the output, accumulator, or mailbox with the address determined in step 4)
        //    8 - Return to the Program Counter to repeat the cycle or halt
        
        state.value = ogState
        
    }
    
    func getInstruction(for register: Register) -> Instruction {
        let opcode = Opcode.add
        let address = 02
        
        return Instruction(opcode: opcode, address: address)
    }
    
    func run(speed: Int) {
        
    }
    
    func arithmaticUnit() {

    }
    
    func accumulator() {
        
    }
}
