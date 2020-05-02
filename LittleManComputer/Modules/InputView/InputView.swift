//
//  InputView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/19/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

protocol EnterValueSheetViewModel {
    var appState: AppState { get }
    var title: LocalizedStringKey { get }
    func enterInput(_ input: String)
}

struct InputView: View {
    @EnvironmentObject var appState: AppState
    @State private var inputValue = ""
    
    var viewModel: EnterValueSheetViewModel
    
    var body: some View {
        VStack {
            SheetTopBar()
            Spacer()
            Text(viewModel.title)
            TextField("000", text: $inputValue)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            LMCButton(title: "enter", height: 50, width: 200) {
                self.viewModel.enterInput(self.inputValue)
            }
            Spacer()
        }
        .alert(isPresented: $appState.showCompileError) {
            Alert(title: Text(appState.compileErrorMessage))
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(viewModel: InputViewModel(appState: AppState()))
    }
}
