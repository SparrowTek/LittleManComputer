//
//  FolderButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct FolderButton: View {
    @State private var openFolder = false
    
    var body: some View {
        Button(action: folderButtonAction) {
            Image(systemName: "folder.fill")
                .foregroundColor(Color(Colors.navBarTitle))
                .frame(width: 30, height: 30)
        }.sheet(isPresented: $openFolder) {
            AssemblyCodeEditor()
        }
    }
    
    private func folderButtonAction() {
        openFolder.toggle()
    }
}

struct FolderButton_Previews: PreviewProvider {
    static var previews: some View {
        FolderButton()
    }
}
