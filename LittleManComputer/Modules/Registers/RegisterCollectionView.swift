//
//  RegisterCollectionView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct RegisterCollectionView: View {
    @Binding var programState: ProgramState
    
    var body: some View {
        VStack {
            HStack {
                Text("ram").padding([.leading, .bottom], 16)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            AllRegisters(programState: $programState)
        }
    }
}

struct AllRegisters: View {
    @Binding var programState: ProgramState
    var body: some View {
        VStack {
            RegisterRow(range: (0...9), programState: $programState)
            RegisterRow(range: (10...19), programState: $programState)
            RegisterRow(range: (20...29), programState: $programState)
            RegisterRow(range: (30...39), programState: $programState)
            RegisterRow(range: (40...49), programState: $programState)
            RegisterRow(range: (50...59), programState: $programState)
            RegisterRow(range: (60...69), programState: $programState)
            RegisterRow(range: (70...79), programState: $programState)
            RegisterRow(range: (80...89), programState: $programState)
            RegisterRow(range: (90...99), programState: $programState)
        }
        .overlay(
        Rectangle()
            .stroke(Color(Colors.registerBorder), lineWidth: 1)
            .padding(-8)
            
        )
    }
}

struct RegisterRow: View {
    private var range: ClosedRange<Int>
    @Binding var programState: ProgramState
    
    init(range: ClosedRange<Int>, programState: Binding<ProgramState>) {
        self.range = range
        _programState = programState
    }
    
    var body: some View {
        HStack {
            ForEach(range, id: \.self) {
                RegisterView(registerNumber: "\($0)", registerValue: self.$programState.registers[$0])
            }
        }
    }
}

//struct RegisterCollectionView_Previews: PreviewProvider {
//    var registers = [506, 107, 902, 108, 902, 000, 001, 010, 003, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
//                     000, 000, 000, 000, 000, 000, 000, 000, 000, 000]
//    private lazy var programState = ProgramState(registers: registers)
//
//    static var previews: some View {
//        RegisterCollectionView(programState: .constant(programState))
//    }
//}
