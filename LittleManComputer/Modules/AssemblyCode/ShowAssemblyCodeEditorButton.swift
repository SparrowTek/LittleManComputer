//
//  ShowAssemblyCodeEditorButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/31/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct ShowAssemblyCodeEditorButton: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        LMCButton(title: "assemblyCodeButton", action: assemblyButtonAction)
            .sheet(isPresented: $appState.showAssemblyCodeEditor) {
                AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: self.appState)).environmentObject(self.appState)
        }
    }
    
    private func assemblyButtonAction() {
        appState.showAssemblyCodeEditor.toggle()
    }
}

struct ShowAssemblyCodeEditorButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowAssemblyCodeEditorButton()
    }
}
