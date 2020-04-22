//
//  LMCButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct LMCButton: View {
    private var title: LocalizedStringKey
    private var action: (() -> Void)?
    private var height: CGFloat
    private var width: CGFloat
    private var exactSize: Bool
    
    init(title: LocalizedStringKey, height: CGFloat, width: CGFloat, action: (() -> Void)?) {
        self.title = title
        self.action = action
        self.height = height
        self.width = width
        exactSize = true
    }
    
    init(title: LocalizedStringKey, maxHeight: CGFloat, maxWidth: CGFloat, action: (() -> Void)?) {
        self.title = title
        self.action = action
        self.height = maxHeight
        self.width = maxWidth
        exactSize = false
    }
    
    var body: some View {
        Button(action: {
            self.action?()
        }) {
            if exactSize {
                Text(title)
                    .frame(width: width, height: height)
                    .background(Color(Colors.lmcButton))
                    .foregroundColor(Color(Colors.lmcButtonTitle))
                    .cornerRadius(16)
            } else {
                Text(title)
                    .frame(maxWidth: width, maxHeight: height)
                    .background(Color(Colors.lmcButton))
                    .foregroundColor(Color(Colors.lmcButtonTitle))
                    .cornerRadius(16)
            }
        }
    }
}

struct LMCButton_Previews: PreviewProvider {
    static var previews: some View {
        LMCButton(title: "assemblyCodeButton", height: 50, width: 200, action: nil)
    }
}
