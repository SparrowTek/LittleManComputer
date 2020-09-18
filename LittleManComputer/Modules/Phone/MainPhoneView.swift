//
//  MainPhoneView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainPhoneView: View {
    @EnvironmentObject var appState: AppState
    
    var viewModel: MainViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                RegisterCollectionView()
                    .padding([.leading, .trailing], 16)
                    .padding(.top, 4)

                Text(appState.programState.printStatement)
                    .frame(height: 30)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding([.leading, .trailing, .bottom], 8)
                    .padding([.top, .bottom], 4)
                MainPhoneGutsView(viewModel: viewModel)
                LMCButton(title: "assemblyCodeButton", maxHeight: appState.isIpad ? 50 : 40, maxWidth: .infinity, action: assemblyButtonAction)
                    .padding([.leading, .trailing], 8)
                    .padding(.bottom, 1)
            }
            .sheet(isPresented: $appState.showSheet) {
                Sheets().environmentObject(self.appState)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("navigationBarTitle", displayMode: .inline)
            .navigationBarItems(trailing: NavBarButtons())
        }
    }
    
    private func assemblyButtonAction() {
        appState.sheetType = .assemblyCodeEditor
    }
    
}

struct MainPhoneGutsView: View {
    @EnvironmentObject var appState: AppState
    var viewModel: MainViewModel
    private var topPadding: CGFloat {
        appState.isIpad ? 8 : 1
    }
    
    var body: some View {
        HStack {
        VStack {
            HStack {
                LMCButton(title: "runButton", height: 30, width: 100, action: runAction)
                LMCButton(title: "stepButton", height: 30, width: 100, action: stepAction)
                Spacer()
            }
            HStack {
                LMCButton(title: "resetButton", height: 30, width: 100, action: resetAction)
                    .padding(.top, 2)
//                Spacer()
                VStack {
                    StateRepresentationView(title: "programCounter", value: $appState.programState.programCounter)
                        .padding(.top, topPadding)
                    StateRepresentationView(title: "accumulator", value: $appState.programState.accumulator)
                        .padding(.top, topPadding)
                }
                Spacer()
            }
        }
        .padding([.leading, .bottom], 2)
            OutboxView()
                .padding(.trailing, 16)
        }
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

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView(viewModel: MainViewModel(appState: AppState())).environmentObject(AppState())
    }
}
