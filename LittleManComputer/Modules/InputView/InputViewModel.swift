//
//  InputViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/19/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation

class InputViewModel {
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func enterInput(_ input: String) {
        appState.virtualMachine.input = Int(input)
        appState.showSheet = false
    }
}
