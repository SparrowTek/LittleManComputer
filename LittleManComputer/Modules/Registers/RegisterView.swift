//
//  RegisterView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    var id = UUID()
    private var registerNumber: String
    var isSelected = false {
        didSet {
            
        }
    }
//    @State private var memoryValue = "000"
    var backgroundColor = Color.white
    var textColor = Color.black
    @Binding var registerValue: Register
    
    init(registerNumber: String, registerValue: Binding<Register>) {
        self.registerNumber = registerNumber
        self._registerValue = registerValue
    }
    
    var body: some View {
        VStack {
            Text(registerNumber)
                .font(.system(size: 12))
                .padding(.bottom, -8)
            TextField("", value: $registerValue, formatter: NumberFormatter())
//            TextField("", text: "\($registerValue)", onEditingChanged: { _ in
//                
//            }, onCommit: {
//                
//            })
                .frame(width: 22, height: 12)
                .multilineTextAlignment(.center)
                .font(.system(size: 10))
                .background(backgroundColor)
                .foregroundColor(textColor)
                .overlay(
                    Rectangle()
                        .stroke(Color(Colors.registerBorder), lineWidth: 1)
            )
            
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(registerNumber: "0", registerValue: .constant(000))
    }
}
