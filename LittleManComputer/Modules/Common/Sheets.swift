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
            InputView(viewModel: InputViewModel(appState: self.appState))
        case .assemblyCodeEditor:
            AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: self.appState))
        case .updateRegister:
            InputView(viewModel: UpdateRegisterViewModel(appState: self.appState))
        case .help:
            HelpView()
                .edgesIgnoringSafeArea(.all)
        case .save:
            SaveNameSheet(show: self.$appState.showSheet, viewModel: FilesViewModel(appState: appState))
        case .folder:
            FolderView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Sheets_Previews: PreviewProvider {
    static var previews: some View {
        Sheets().environmentObject(AppState())
    }
}
