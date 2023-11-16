//
//  HelpButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct HelpButton: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: helpButtonAction) {
            Image(systemName: "questionmark")
                .foregroundColor(Color(Colors.navBarTitle))
                .frame(width: 30, height: 30)
        }
    }
    
    private func helpButtonAction() {
        appState.sheetType = .help
        appState.showSheet = true
    }
}

struct HelpButton_Previews: PreviewProvider {
    static var previews: some View {
        HelpButton().environmentObject(AppState())
    }
}
