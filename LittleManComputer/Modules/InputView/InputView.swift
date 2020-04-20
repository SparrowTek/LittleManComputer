//
//  InputView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/19/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var appState: AppState
    @State private var inputValue = ""
    
    var viewModel: InputViewModel
    
    var body: some View {
        VStack {
            Text("inputNeeded")
            TextField("000", text: $inputValue)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            LMCButton(title: "enter") {
                self.viewModel.enterInput(self.inputValue)
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(viewModel: InputViewModel(appState: AppState())).environmentObject(AppState())
    }
}
