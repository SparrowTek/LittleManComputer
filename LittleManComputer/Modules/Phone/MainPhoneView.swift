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
                RegisterCollectionView().environmentObject(appState)
                    .frame(maxWidth: .infinity, maxHeight: 375, alignment: .center)
                    .padding([.leading, .trailing], 16)
                    
                Text(appState.programState.printStatement)
                    .frame(height: 30)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.top, 16)
                    .padding([.leading, .trailing, .bottom], 8)
                    .padding([.top, .bottom], 8)
                HStack {
                    VStack {
                        HStack {
                            LMCButton(title: "runButton", height: 30, width: 100, action: runAction)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        HStack {
                            LMCButton(title: "stepButton", height: 30, width: 100, action: stepAction)
                                .padding(.leading, 20)
                            Spacer()
                        }.padding(.top, 8)
                        HStack {
                            LMCButton(title: "resetButton", height: 30, width: 100, action: resetAction)
                                .padding(.leading, 20)
                            Spacer()
                        }.padding(.top, 8)
                        StateRepresentationView(title: "programCounter", value: $appState.programState.programCounter)
                            .padding(.top, 8)
                            .padding(.leading, 16)
                        StateRepresentationView(title: "accumulator", value: $appState.programState.accumulator)
                            .padding(.top, 8)
                            .padding(.leading, 16)
                    }
                    .padding(.top, 8)
                    
                    OutboxView().environmentObject(appState)
                }
                Spacer()
                LMCButton(title: "assemblyCodeButton", maxHeight: 50, maxWidth: .infinity, action: assemblyButtonAction)
                    .padding([.leading, .trailing], 8)
                
            }
            .sheet(isPresented: $appState.showSheet) {
                if self.appState.sheetType == SheetType.inputNeeded {
                    InputView(viewModel: InputViewModel(appState: self.appState)).environmentObject(self.appState)
                } else if self.appState.sheetType == SheetType.assemblyCodeEditor {
                    AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: self.appState)).environmentObject(self.appState)
                } else if self.appState.sheetType == SheetType.updateRegister {
                    InputView(viewModel: UpdateRegisterViewModel(appState: self.appState)).environmentObject(self.appState)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle("navigationBarTitle", displayMode: .inline)
            .navigationBarItems(trailing: NavBarButtons())
            
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

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView(viewModel: MainViewModel(appState: AppState())).environmentObject(AppState())
    }
}
