//
//  MainTabletView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainTabletView: View {
    @EnvironmentObject var appState: AppState
    var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            NavBar()
            Spacer()
            
            HStack {
                AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: appState))
                    .frame(width: 350)
                    .padding(.bottom, 16)
                VStack {
                    RegisterCollectionView().environmentObject(appState)
                        .frame(maxWidth: 550, maxHeight: 400, alignment: .center)
                        .padding([.top, .bottom], 96)
                        .padding(.trailing, 16)
                    Text(appState.programState.printStatement)
                        .frame(height: 30)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 16)
                        .padding([.leading, .trailing, .bottom], 8)
                    Spacer()
                    
                    HStack {
                        VStack {
                            StateRepresentationView(title: "programCounter", value: $appState.programState.programCounter)
                                .padding(.top, 8)
                                .padding(.leading, 16)
                            StateRepresentationView(title: "accumulator", value: $appState.programState.accumulator)
                                .padding(.top, 8)
                                .padding([.leading, .bottom], 16)
                            
                            HStack {
                                LMCButton(title: "runButton", height: 30, width: 100, action: runAction)
                                LMCButton(title: "stepButton", height: 30, width: 100, action: stepAction)
                                LMCButton(title: "resetButton", height: 30, width: 100, action: resetAction)
                            }
                        }
                        .padding(.top, -32)
                        OutboxView().environmentObject(appState)
                            .padding(.top, -32)
                            .padding(.trailing, 16)
                            .padding(.bottom, 8)
                    }
                }
                
            }
        }
        .sheet(isPresented: $appState.showSheet) {
            Sheets().environmentObject(self.appState)
        }
    }
    
    private func assemblyButtonAction() {
        appState.sheetType = .assemblyCodeEditor
    }
    
    private func runAction() {
        viewModel.run()
    }
    
    private func stepAction() {
        viewModel.step()
    }
    
    private func resetAction() {
        viewModel.reset()
    }
}

struct NavBar: View {
    var body: some View {
        ZStack {
            HStack {
                Text("navigationBarTitle_iPad")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(Color(Colors.navBarTitle))
            }
            HStack {
                Spacer()
                NavBarButtons()
                    .padding(.trailing, 16)
            }
        }
        .padding([.top, .bottom], 16)
    }
}

struct MainTabletView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabletView(viewModel: MainViewModel(appState: AppState())).environmentObject(AppState())
    }
}
