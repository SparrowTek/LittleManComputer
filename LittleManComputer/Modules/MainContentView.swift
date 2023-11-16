//
//  MainContentView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/3/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    
    var body: some View {
        if appState.isIpad && horizontalSizeClass == .regular {
            MainTabletView(viewModel: MainViewModel(appState: appState))
        } else {
            MainPhoneView(viewModel: MainViewModel(appState: appState))
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView().environmentObject(AppState())
    }
}
