//
//  InputViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/19/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

class InputViewModel: EnterValueSheetViewModel {
    var appState: AppState
    var title: LocalizedStringKey = "inputNeeded"
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func enterInput(_ input: String) {
        appState.updateInput(Int(input))
        appState.showSheet = false
    }
}
