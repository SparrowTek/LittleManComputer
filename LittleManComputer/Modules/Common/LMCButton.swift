//
//  LMCButton.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/4/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct LMCButton: View {
    private var title: String
    private var action: (() -> Void)?
    private var height: CGFloat
    private var width: CGFloat
    
    init(title: String, height: CGFloat = 50, width: CGFloat = 200, action: (() -> Void)?) {
        self.title = title
        self.action = action
        self.height = height
        self.width = width
    }
    
    var body: some View {
        Button(action: {
            self.action?()
        }) {
            Text(title)
            .frame(width: width, height: height)
            .background(Color(Colors.lmcButton))
            .foregroundColor(Color(Colors.lmcButtonTitle))
            .cornerRadius(16)
        }
    }
}

struct LMCButton_Previews: PreviewProvider {
    static var previews: some View {
        LMCButton(title: "assemblyCodeButton", action: nil)
    }
}
