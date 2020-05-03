//
//  SheetTopBar.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/2/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct SheetTopBar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: RoundedCornerStyle.circular)
            .frame(width: 50, height: 4, alignment: .center)
            .background(Color(Colors.sheetTopBar))
            .padding(.top, 8)
    }
}

struct SheetTopClose: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.appState.showSheet = false
            }) {
                Image(systemName: "xmark.circle")
                .font(Font.system(.largeTitle))
                .foregroundColor(Color(Colors.lmcButton))
            }
            .padding(16)
        }
    }
}

struct SheetTopBar_Previews: PreviewProvider {
    static var previews: some View {
        SheetTopBar()
//        SheetTopClose().EnvironmentObject(AppState())
    }
}
