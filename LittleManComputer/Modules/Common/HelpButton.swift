//
//  HelpButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct HelpButton: View {
    @State private var showHelp = false
    
    var body: some View {
        Button(action: helpButtonAction) {
            Image(systemName: "questionmark")
                .foregroundColor(Color(Colors.navBarTitle))
                .frame(width: 30, height: 30)
        }.sheet(isPresented: $showHelp) {
            Text("Help")
        }
    }
    
    private func helpButtonAction() {
        showHelp.toggle()
    }
}

struct HelpButton_Previews: PreviewProvider {
    static var previews: some View {
        HelpButton()
    }
}
