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
    var title: LocalizedStringKey = "UPDATE LOCALIZABLE FILE"
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func enterInput(_ input: String) {
        guard let input = Int(input) else {
            #warning("handle error. this should be an integer")
            return
        }

        appState.updateRegister(with: input)
        appState.showSheet = false
    }
}
