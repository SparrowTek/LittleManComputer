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
    
    @Published var programState = ProgramState() /*{
        didSet {
            virtualMachine.state.value = programState
        }
    }*/
    @Published var showCompileError = false
    @Published var compileErrorMessage = ""
    @Published var sourceCode = ""
    @Published var sheetType = SheetType.assemblyCodeEditor
    @Published var showSheet = false
    
    lazy var virtualMachine = VirtualMachine(state: programState)
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
}
