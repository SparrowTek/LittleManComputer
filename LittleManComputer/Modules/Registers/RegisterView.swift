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
    @State private var memoryValue = "000"
    private var registerNumber: String
    
    init(registerNumber: String) {
        self.registerNumber = registerNumber
    }
    
    var body: some View {
        VStack {
            Text(registerNumber)
                .font(.system(size: 12))
                .padding(.bottom, -8)
            TextField("", text: $memoryValue, onEditingChanged: { _ in
                
            }, onCommit: {
                
            })
                .frame(width: 22, height: 12)
                .multilineTextAlignment(.center)
                .font(.system(size: 10))
                .overlay(
                    Rectangle()
                        .stroke(Color(Colors.registerBorder), lineWidth: 1)
            )
            
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(registerNumber: "0")
    }
}
