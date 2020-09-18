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
                .background(Color(Colors.navBar))
            Spacer()
            
            HStack {
                AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: appState))
                    .frame(width: 350)
                    .padding(.bottom, 8)
                MainTabletGutsView(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $appState.showSheet) {
            Sheets().environmentObject(self.appState)
        }
    }
}

struct NavBar: View {
    @EnvironmentObject var appState: AppState
    
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
                    .padding(.top, 30)
            }
        }
        .padding(.top, 16)
    }
}

struct MainTabletGutsView: View {
    @EnvironmentObject var appState: AppState
    var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            RegisterCollectionView()
                .padding(.trailing, 16)
            Text(appState.programState.printStatement)
                .frame(height: 30)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .padding([.top, .bottom], 1)
                .padding([.leading, .trailing], 8)
            Spacer()
            
            HStack {
                VStack {
                    StateRepresentationView(title: "programCounter", value: $appState.programState.programCounter)
                        .padding(.top, 1)
                        .padding(.leading, 16)
                    StateRepresentationView(title: "accumulator", value: $appState.programState.accumulator)
                        .padding(.top, 1)
                        .padding([.leading, .bottom], 16)
                    
                    HStack {
                        LMCButton(title: "runButton", height: 30, width: 100, action: runAction)
                        LMCButton(title: "stepButton", height: 30, width: 100, action: stepAction)
                        LMCButton(title: "resetButton", height: 30, width: 100, action: resetAction)
                    }
                }
                .padding(.top, -32)
                OutboxView()
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
            }
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

struct MainTabletView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabletView(viewModel: MainViewModel(appState: AppState())).environmentObject(AppState())
    }
}
