//
//  UpdateRegisterViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/26/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

class UpdateRegisterViewModel: EnterValueSheetViewModel {
    var appState: AppState
    var title: LocalizedStringKey = "enterNewRegisterValue"
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func enterInput(_ input: String) {
        guard let input = Int(input),
            input >= 0 && input < 1000 else {
            appState.showCompileError(.intExpected)
            return
        }

        appState.updateRegister(with: input)
        appState.showSheet = false
    }
}
