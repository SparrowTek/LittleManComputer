//
//  AssemblyCodeEditor.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct AssemblyCodeEditor: View {
    @EnvironmentObject var appState: AppState
    let viewModel: AssemblyCodeEditorViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("assemblyCodeEditorTitle")
                    .padding([.leading], 32)
                    .padding(.top, 16)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            TextView(text: $appState.sourceCode)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(Colors.textEditorBackground))
            .padding([.leading, .trailing], 20)
            Spacer()
            LMCButton(title: "compileCodeButton", width: .infinity, action: compile)
            .padding([.leading, .trailing])
        }
    }
    
    private func compile() {
        viewModel.compileCode(appState.sourceCode)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.textColor = UIColor(named: Colors.textEditorText)
        textView.backgroundColor = UIColor(named: Colors.textEditorBackground)
        textView.font = .systemFont(ofSize: 18)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .allCharacters
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct AssemblyCodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: AppState()))
    }
}
