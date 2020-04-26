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
        VStack {
            Text("\(registerNumber)")
            .font(.system(size: 12))
            .padding(.bottom, 4)
            Button(action: {
                self.appState.registerToUpdate = self.registerNumber
            }) {
                Text(appState.programState.registers[registerNumber].display)
                .frame(width: 22, height: 12)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10))
                    .background(Color(Colors.registerBackground))
                    .foregroundColor(Color(Colors.registerText))
                    .overlay(
                        Rectangle()
                            .stroke(Color(Colors.registerBorder), lineWidth: 1)
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
