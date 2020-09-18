//
//  AssemblyCodeEditor.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct AssemblyCodeEditor: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var appState: AppState
    let viewModel: AssemblyCodeEditorViewModel
    private var isIpadAndRegularWidth: Bool { appState.isIpad && horizontalSizeClass == .regular }
    
    var body: some View {
        VStack {
            if isIpadAndRegularWidth { 
                Text("assemblyCodeEditorTitle")
                .padding(.top, 1)
                .font(.system(size: 20, weight: .bold))
            } else {
                SheetTopBar()
                Spacer()
                HStack {
                    Text("assemblyCodeEditorTitle")
                        .padding([.leading], 32)
                        .padding(.top, 16)
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
            }
            
//            TextEditor(text: $appState.sourceCode)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .padding([.leading, .trailing], 20)
//                .background(Color(Colors.textEditorBackground))
//                .opacity(0.5)
//                .font(.system(size: 18))
//                .foregroundColor(Color.green)
//                .keyboardType(.numberPad)
//                .autocapitalization(.allCharacters)
//                .disableAutocorrection(true)
                
            
            TextView(sourceCode: $appState.sourceCode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(Colors.textEditorBackground))
                .padding([.leading, .trailing], 20)
            LMCButton(title: "compileCodeButton", maxHeight: 50, maxWidth: .infinity, action: compile)
                .padding([.leading, .trailing])
        }
        .alert(isPresented: $appState.showCompileError) {
            Alert(title: Text(appState.alertMessage))
        }
    }
    
    private func compile() {
        viewModel.compileCode(appState.sourceCode)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var sourceCode: String
    
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
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = sourceCode
    }
    
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var control: TextView
        
        init(_ control: TextView) {
            self.control = control
        }
        
        func textViewDidChange(_ textView: UITextView) {
            control.sourceCode = textView.text
        }
    }
}

struct AssemblyCodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: AppState())).environmentObject(AppState())
    }
}
