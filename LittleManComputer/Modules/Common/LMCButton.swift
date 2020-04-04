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
    
    init(title: String, action: (() -> Void)?) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            self.action?()
        }) {
            Text(title)
        }
        
            
    }
}

struct LMCButton_Previews: PreviewProvider {
    static var previews: some View {
        LMCButton(title: "title", action: nil)
    }
}
