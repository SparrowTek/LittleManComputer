//
//  MainPhoneViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/5/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine

class MainPhoneViewModel {
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func run() {
        appState.runVirtualMachine()
    }
    
    func step() {
        appState.stepVirtualMaching()
    }
    
    func reset() {
        appState.reset()
    }
}
