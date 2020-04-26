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
            appState.programState = try appState.compiler.compile(code)
            appState.updateVirtualMachine()
            appState.showSheet = false
        } catch (let error as CompileError) {
            appState.showError(error)
        } catch {
            appState.showError(.general)
        }
    }
}
