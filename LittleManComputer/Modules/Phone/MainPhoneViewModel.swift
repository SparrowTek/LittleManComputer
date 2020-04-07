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
//    private lazy var virtualMachine = VirtualMachine(state: programState)
    private let vm: VirtualMachine
    private var cancelable: AnyCancellable?
    
    init() {
        let state = ProgramState(registers: registers)
//        programState = ProgramState(registers: registers)
        programState = state
        vm = VirtualMachine(state: state)
        subscribeToState()
    }
    
    private func subscribeToState() {
        cancelable = vm.state.sink(receiveCompletion: { completion in
            print("completion: \n\(completion)")
        }, receiveValue: { state in
            self.programState = state
        })
    }
    
    func run() {
        vm.run(speed: 1)
    }
    
    func step() {
        vm.step()
    }
    
    func reset() {
        #warning("implement reset()")
    }
}
