//
//  FolderButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct FolderButton: View {
    @EnvironmentObject var appState: AppState
    @State private var showActionSheet = false
    let viewModel: FilesViewModel
    
    var body: some View {
        Button(action: folderButtonAction) {
            Image(systemName: "folder.fill")
                .foregroundColor(Color(Colors.navBarTitle))
                .frame(width: 30, height: 30)
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("folderAlertTitle"), message: Text("folderAlertSubTitle"), buttons: [
                .default(Text("load"), action: load),
                .default(Text("save"), action: save),
                .cancel()
            ])
        }
        .alert(isPresented: $appState.shouldShowAlert) {
            Alert(title: Text(appState.alertMessage))
        }
    }
    
    private func folderButtonAction() {
        showActionSheet.toggle()
    }
    
    private func load() {
        appState.sheetType = .folder
        appState.showSheet = true
    }
    
    private func save() {
        appState.sheetType = .save
        appState.showSheet = true
    }
}

struct SaveNameSheet: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var appState: AppState
    @State private var programName = ""
    @Binding var show: Bool
    private var isIpadAndRegularWidth: Bool { appState.isIpad && horizontalSizeClass == .regular }
    
    let viewModel: FilesViewModel
    
    var body: some View {
        VStack {
            if isIpadAndRegularWidth {
                SheetTopClose()
            } else {
                SheetTopBar()
            }
            Spacer()
            Text("saveNameTitle")
            TextField("saveNamePlaceholder", text: $programName)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .padding(.bottom, 8)
            LMCButton(title: "save", height: 50, width: 200) {
                self.viewModel.saveProgramAs(self.programName)
                self.show.toggle()
            }
            Spacer()
        }
    }
}

struct FolderButton_Previews: PreviewProvider {
    static var previews: some View {
        FolderButton(viewModel: FilesViewModel(appState: AppState()))
    }
}
