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
            Text("Assembly Code")
        }.sheet(isPresented: $showAssemblyCodeEditor) {
            AssemblyCodeEditor()
        }
        .edgesIgnoringSafeArea(.bottom)
//        ShowAssemblyCodeEditorButtonContent()
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ShowAssemblyCodeEditorButtonContent: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(Colors.sheetHandle))
                .frame(width: 80, height: 8)
                .shadow(radius: 0.5)
                .padding(.top, 8)
            HStack {
                Text("Assembly Code")
                    .padding([.leading], 32)
                Spacer()
            }
            Rectangle()
                .fill(Color(Colors.textEditorBackground))
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 20)
            }
        .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color(Colors.sheetBoarder), lineWidth: 1)
        )
        
    }
}

struct ShowAssemblyCodeEditorButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowAssemblyCodeEditorButton()
    }
}
