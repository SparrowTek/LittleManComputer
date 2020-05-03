//
//  Sheets.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/3/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct Sheets: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        switch appState.sheetType {
        case .inputNeeded:
            return AnyView(InputView(viewModel: InputViewModel(appState: self.appState)).environmentObject(self.appState))
        case .assemblyCodeEditor:
            return AnyView(AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: self.appState)).environmentObject(self.appState))
        case .updateRegister:
            return AnyView(InputView(viewModel: UpdateRegisterViewModel(appState: self.appState)).environmentObject(self.appState))
        }
    }
}

struct Sheets_Previews: PreviewProvider {
    static var previews: some View {
        Sheets().environmentObject(AppState())
    }
}
