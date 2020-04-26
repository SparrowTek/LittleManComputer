//
//  RegisterView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    var id = UUID()
    private var registerNumber: Int
    var isSelected = false {
        didSet {
            
        }
    }
    var backgroundColor = Color(Colors.registerBackground)
    var textColor = Color(Colors.registerText)
    
    init(registerNumber: Int) {
        self.registerNumber = registerNumber
    }
    
    var body: some View {
        VStack {
            Text("\(registerNumber)")
                .font(.system(size: 12))
                .padding(.bottom, -8)
//            TextField("", value: $appState.programState.registers[registerNumber], formatter: NumberFormatter(), onEditingChanged: { _ in
//
//            }, onCommit: {
//                self.appState.programState.registers[self.registerNumber] = self.registerValue
//            })
//            TextField("", value: $name /*$appState.programState.registers[registerNumber]*/, formatter: NumberFormatter())
            TextField("", text: $appState.programState.registers[registerNumber].display)
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
        RegisterView(registerNumber: 0).environmentObject(AppState())
    }
}
