//
//  AssemblyCodeEditor.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct AssemblyCodeEditor: View {
    //    @ObservedObject var viewModel: AssemblyCodeEditorViewModel
    let viewModel = AssemblyCodeEditorViewModel()
    @State private var sourceCode = """
INP
OUT
HLT
wh
okokok
flkdflkmds

"""
    
    var body: some View {
        VStack {
            HStack {
                Text("assemblyCodeEditorTitle")
                    .padding([.leading], 32)
                    .padding(.top, 16)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            MultilineTextView(text: $sourceCode)
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
        viewModel.compileCode(sourceCode)
    }
}

struct MultilineTextView: UIViewRepresentable {
    
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.textColor = UIColor(named: Colors.textEditorText)
        view.backgroundColor = UIColor(named: Colors.textEditorBackground)
        view.font = .systemFont(ofSize: 18)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct AssemblyCodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        AssemblyCodeEditor()
    }
}
