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
    let compiler = Compiler()
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func compileCode(_ code: String) {
        do {
            appState.programState = try compiler.compile(code)
            appState.updateVirtualMachine()
            appState.showSheet = false
        } catch (let error as CompileError) {
            appState.showCompileError(error)
        } catch {
            appState.showCompileError(.general)
        }
    }
}
