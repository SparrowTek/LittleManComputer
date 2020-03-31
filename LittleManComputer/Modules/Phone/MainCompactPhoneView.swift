//
//  MainCompactPhoneView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/31/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainCompactPhoneView: View {
    var body: some View {
        NavigationView {
            ShowAssemblyCodeEditorButton()
        }
        .navigationBarTitle("Little Man Computer", displayMode: .inline)
    }
}

struct MainCompactPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainCompactPhoneView()
    }
}
