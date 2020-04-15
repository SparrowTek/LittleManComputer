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

class AppState: ObservableObject {
    
    @Published var programState = ProgramState() /*{
        didSet {
            virtualMachine.state.value = programState
        }
    }*/
    @Published var showCompileError = false
    @Published var compileErrorMessage = ""
    @Published var sourceCode = ""
    @Published var showAssemblyCodeEditor = false
    @Published var showInputAlert = false
    
    lazy var virtualMachine = VirtualMachine(state: programState)
    let compiler = Compiler()
}
