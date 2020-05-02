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
    
    var viewModel: MainPhoneViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                RegisterCollectionView().environmentObject(appState)
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
                    
                    OutboxView(outbox: $appState.programState.outbox)
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
                    InputView(viewModel: UpdateRegisterViewModel(appState: self.appState))
                }
            }
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

struct StateRepresentationView: View {
    private var title = ""
    @Binding var value: Int
    
    init(title: String, value: Binding<Int>) {
        self.title = title
        self._value = value
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .lineLimit(1)
            Text("\(value)")
                .font(.system(size: 12))
            Spacer()
        }
    }
}

struct OutboxView: View {
    @Binding var outbox: [Int]
    
    var body: some View {
        VStack {
            Text("outboxTitle")
            
            
            List {
                ForEach(outbox, id: \.self) {
                    Text($0.toStringWith3IntegerDigits())
                        .frame(height: 10)
                        .foregroundColor(Color(Colors.outboxText))
                        .listRowBackground(Color(Colors.outboxBackground))
                }
            }
            .environment(\.defaultMinListRowHeight, 10)
            .frame(width: 75, height: 150)
            .background(Color(Colors.outboxBackground))
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
        }
        .frame(width: 150, height: 150)
    }
}

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView(viewModel: MainPhoneViewModel(appState: AppState())).environmentObject(AppState())
    }
}
