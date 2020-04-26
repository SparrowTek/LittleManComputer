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
    var backgroundColor = Color(Colors.registerBackground)
    var textColor = Color(Colors.registerText)
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
                .keyboardType(.numberPad)
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
