//
//  RegisterCollectionView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct RegisterCollectionView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var appState: AppState
    
    private var isIpadAndRegularWidth: Bool { appState.isIpad && horizontalSizeClass == .regular }
    
    var body: some View {
        VStack {
            if isIpadAndRegularWidth {
                Text("ram")
                    .padding(.bottom, 1)
                    .font(.system(size: 20, weight: .bold))
            } else {
                HStack {
                    Text("ram")
                        .padding(.bottom, 4)
                        .padding(.leading, 48)
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                }
//                .padding(.top, 8)
            }
            AllRegisters()
        }
    }
}

struct AllRegisters: View {
    var body: some View {
        VStack {
            RegisterRow(range: (0...9))
            RegisterRow(range: (10...19))
            RegisterRow(range: (20...29))
            RegisterRow(range: (30...39))
            RegisterRow(range: (40...49))
            RegisterRow(range: (50...59))
            RegisterRow(range: (60...69))
            RegisterRow(range: (70...79))
            RegisterRow(range: (80...89))
            RegisterRow(range: (90...99))
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
    @EnvironmentObject var appState: AppState
    
    init(range: ClosedRange<Int>) {
        self.range = range
    }
    
    var body: some View {
        HStack {
            ForEach(range, id: \.self) {
                RegisterView(registerNumber: $0).environmentObject(self.appState)
                    .padding(.top, 1)
            }
        }
    }
}

struct RegisterCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCollectionView().environmentObject(AppState())
    }
}
