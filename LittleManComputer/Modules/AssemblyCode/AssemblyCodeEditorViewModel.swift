//
//  AssemblyCodeEditorViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/6/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation

class AssemblyCodeEditorViewModel {
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func compileCode(_ code: String) {
        do {
            appState.virtualMachine.state.value = try appState.compiler.compile(code)
            appState.showAssemblyCodeEditor = false
        } catch (let error as CompileError) {
            switch error {
            case .intExpected:
                break
            case .invalidAssemblyCode:
                break
            }
            
            appState.showCompileError = true
        } catch {
            #warning("catch all")
        }
    }
}
