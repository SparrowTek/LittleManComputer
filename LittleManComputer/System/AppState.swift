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
    
    @Published var programState = ProgramState()
    lazy var virtualMachine = VirtualMachine(state: programState)
    let compiler = Compiler()
    
    @Published var showCompileError = false
    @Published var compileErrorMessage = ""
    @Published var sourceCode = """
    INP
    OUT
    HLT
    """
    
    @Published var showAssemblyCodeEditor = false
}
