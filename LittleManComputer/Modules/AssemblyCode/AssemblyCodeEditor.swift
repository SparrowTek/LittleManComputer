//
//  AssemblyCodeEditor.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct AssemblyCodeEditor: View {
    
    var body: some View {
//        HStack {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .foregroundColor(.white)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .edgesIgnoringSafeArea(.all)
        
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
//        .overlay(
//        RoundedRectangle(cornerRadius: 16)
//            .stroke(Color(Colors.sheetBoarder), lineWidth: 1)
//        )
    }
}

struct AssemblyCodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        AssemblyCodeEditor()
    }
}
