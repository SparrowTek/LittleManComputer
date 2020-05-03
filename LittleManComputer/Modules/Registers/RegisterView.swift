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
    private var registerNumber: Int
    
    init(registerNumber: Int) {
        self.registerNumber = registerNumber
    }
    
    var body: some View {
        if appState.programState.registersCurrentlyBeingEvaluated[registerNumber] ?? false {
            return RegisterViewSelected(registerNumber: registerNumber, backgroundColor: Color(Colors.highlightedRegisterBackground), textColor: Color(Colors.highlightedRegisterText), borderColor: Color(Colors.highlightedRegisterBorder)).environmentObject(appState)
        } else {
            return RegisterViewSelected(registerNumber: registerNumber, backgroundColor: Color(Colors.registerBackground), textColor: Color(Colors.registerText), borderColor: Color(Colors.registerBorder)).environmentObject(appState)
        }
    }
}

struct RegisterViewSelected: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private var registerNumber: Int
    private var backgroundColor: Color
    private var textColor: Color
    private var borderColor: Color
//    private var width: CGFloat { horizontalSizeClass == .compact ? 22 : 66 }
//    private var height: CGFloat { horizontalSizeClass == .compact ? 12 : 24 }
    private var fontSize: CGFloat { horizontalSizeClass == .compact ? 10 : 18 }
    private var titleFontSize: CGFloat {horizontalSizeClass == .compact ? 12 : 20 }
    
    init(registerNumber: Int, backgroundColor: Color, textColor: Color, borderColor: Color) {
        self.registerNumber = registerNumber
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
    }
    
    var body: some View {
        VStack {
            Text("\(registerNumber)")
                .font(.system(size: titleFontSize))
                .padding(.bottom, 4)
            Button(action: {
                self.appState.registerToUpdate = self.registerNumber
            }) {
                Text(appState.programState.registers[registerNumber].toStringWith3IntegerDigits())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(4)
                    .multilineTextAlignment(.center)
                    .font(.system(size: fontSize))
                    .minimumScaleFactor(0.9)
                    .background(backgroundColor)
                    .foregroundColor(textColor)
                    .overlay(
                        Rectangle()
                            .stroke(borderColor, lineWidth: 1)
                )
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(registerNumber: 0).environmentObject(AppState())
    }
}
