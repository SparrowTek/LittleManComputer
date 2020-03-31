//
//  ShowAssemblyCodeEditorButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/31/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct ShowAssemblyCodeEditorButton: View {
    @State var showAssemblyCodeEditor = false
    var body: some View {
        Button(action: {
            self.showAssemblyCodeEditor.toggle()
        }) {
            ShowAssemblyCodeEditorButtonContent()
        }.sheet(isPresented: $showAssemblyCodeEditor) {
            AssemblyCodeEditor()
        }
        
    }
}

struct ShowAssemblyCodeEditorButtonContent: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.black)
                .frame(width: 80, height: 8)
            Text("Assembly Code")
        }
    }
}

struct ShowAssemblyCodeEditorButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowAssemblyCodeEditorButton()
    }
}
