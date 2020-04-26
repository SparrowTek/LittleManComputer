//
//  AppState.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/12/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

enum SheetType {
    case inputNeeded
    case assemblyCodeEditor
}

class AppState: ObservableObject {
    @Published var programState = ProgramState()
    @Published var showCompileError = false
    @Published var compileErrorMessage: LocalizedStringKey = ""
    @Published var sourceCode = ""
    @Published var sheetType = SheetType.assemblyCodeEditor
    @Published var showSheet = false
    
    private lazy var virtualMachine = VirtualMachine(state: programState)
    let compiler = Compiler()
    private var cancelable: AnyCancellable?
    
    init() {
        subscribeToState()
    }
    
    private func subscribeToState() {
        cancelable = virtualMachine.state.sink(receiveCompletion: { completion in
            print("completion: \n\(completion)")
            if completion == .failure(.needInput) {
                self.sheetType = .inputNeeded
                self.showSheet = true
            }
            self.resetVirtualMachine()
        }, receiveValue: { state in
            self.programState = state
        })
    }
    
    private func resetVirtualMachine() {
        virtualMachine = VirtualMachine(state: programState)
        subscribeToState()
    }
    
    func updateVirtualMachine() {
        virtualMachine.state.value = programState
    }
    
    func runVirtualMachine(speed: Double = 1) {
        virtualMachine.run(speed: speed)
    }
    
    func stepVirtualMaching() {
        virtualMachine.step()
    }
    
    func updateInput(_ input: Int?) {
        virtualMachine.input = input
    }
    
    func showError(_ error: CompileError) {
        let errorMessage: LocalizedStringKey
        
        switch error {
        case .intExpected:
            errorMessage = "intExpectedError"
        case .invalidAssemblyCode:
            errorMessage = "invalidAssemblyCodeError"
        case .general:
            errorMessage = "generalError"
        }
        
        compileErrorMessage = errorMessage
        showCompileError = true
    }
}
