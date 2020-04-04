//
//  MainPhoneView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainPhoneView: View {
    @State var showAssemblyCodeEditor = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                RegisterCollectionView()
                ShowAssemblyCodeEditorButton()
                    .frame(maxHeight: 64)
                    .navigationBarTitle("navigationBarTitle", displayMode: .inline)
                .navigationBarItems(trailing: NavBarButtons())
            }
        }
    }
}

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView()
    }
}
