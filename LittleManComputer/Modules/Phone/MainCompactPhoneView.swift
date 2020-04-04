//
//  MainCompactPhoneView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/31/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainCompactPhoneView: View {
    @State var showAssemblyCodeEditor = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ShowAssemblyCodeEditorButton()
                    .frame(maxHeight: 64)
                    .navigationBarTitle("Little Man Computer", displayMode: .inline)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { gesture in
//                                self.showAssemblyCodeEditor = true
//                        }
//                )
//                    .sheet(isPresented: $showAssemblyCodeEditor) {
//                        AssemblyCodeEditor()
//                }
            }
            
        }
        
    }
}

struct MainCompactPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainCompactPhoneView()
    }
}
