//
//  MainPhoneViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/5/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine

class MainPhoneViewModel: ObservableObject {
    @Published var programState: ProgramState
//    private let registers = [Register](repeating: 000, count: 100)
    private let registers = [506, 107, 902, 108, 902, 000, 001, 010, 003, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
    000, 000, 000, 000, 000, 000, 000, 000, 000, 000]
    private let compiler = Compiler()
    private lazy var virtualMachine = VirtualMachine(state: programState)
    
    init() {
        programState = ProgramState(registers: registers)
    }
    
    func run() {
        virtualMachine.run(speed: 1)
    }
    
    func step() {
        virtualMachine.step()
    }
    
    func reset() {
        #warning("implement reset()")
    }
    
    func compile(_ code: String) {
        do {
            programState = try compiler.compile(code)
        } catch {
            #warning("handle catch")
        }
    }
}
