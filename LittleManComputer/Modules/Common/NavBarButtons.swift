//
//  NavBarButtons.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct NavBarButtons: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            FolderButton(viewModel: FilesViewModel(appState: appState))
            HelpButton()
        }
    }
}

struct NavBarButtons_Previews: PreviewProvider {
    static var previews: some View {
        NavBarButtons()
    }
}
