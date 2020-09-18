//
//  LittleManComputerApp.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 6/22/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

@main
struct LittleManComputerApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        setupGlobalUIElements()
    }
    
    var body: some Scene {
        WindowGroup {
            MainContentView().environmentObject(appState)
        }
    }
    
    private func setupGlobalUIElements() {
        UINavigationBar.appearance().barTintColor = UIColor(named: Colors.navBar)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: Colors.navBarTitle) ?? UIColor.black]
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
