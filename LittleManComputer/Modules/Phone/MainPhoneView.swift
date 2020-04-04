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
    @State var printStatement = "printStatement"
    
    var body: some View {
        NavigationView {
            VStack {
                RegisterCollectionView()
                HStack {
                    ShowAssemblyCodeEditorButton()
                        .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 16)
                VStack {
                    HStack {
                        LMCButton(title: "runButton", height: 30, width: 100, action: runAction)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    HStack {
                        LMCButton(title: "StepButton", height: 30, width: 100, action: runAction)
                            .padding(.leading, 20)
                        Spacer()
                    }.padding(.top, 8)
                    HStack {
                        LMCButton(title: "resetButton", height: 30, width: 100, action: runAction)
                            .padding(.leading, 20)
                        Spacer()
                    }.padding(.top, 8)
                }
                .padding(.top, 8)
                Spacer()
                Text(printStatement)
                    .padding()
                
                .padding(.bottom, 16)
                .navigationBarTitle("navigationBarTitle", displayMode: .inline)
                .navigationBarItems(trailing: NavBarButtons())
            }
        }
    }
    
    private func runAction() {
        
    }
}

/**
 Program counter
 details
 Accumulator
 output
 ram title
 run button
 step button
 reset button
 assemble into ram button should be in the AssemblyCodeEditor view
 */

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView()
    }
}
