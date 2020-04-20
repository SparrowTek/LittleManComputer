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
                RegisterCollectionView()
                HStack {
                    LMCButton(title: "assemblyCodeButton", action: assemblyButtonAction)
                        .padding(.leading, 20)
                    Spacer()
                }
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
                    }
                    .padding(.top, 8)
                    VStack {
                        StateRepresentationView(title: "programCounter", value: $appState.programState.programCounter)
                        StateRepresentationView(title: "accumulator", value: $appState.programState.accumulator)
                    }
                    Spacer()
                    OutboxView(outbox: $appState.programState.outbox)
                }
                Spacer()
                Text(appState.programState.printStatement)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom, 16)
                    .padding([.leading, .trailing], 8)
                    .navigationBarTitle("navigationBarTitle", displayMode: .inline)
                    .navigationBarItems(trailing: NavBarButtons())
            }
            .sheet(isPresented: $appState.showSheet) {
                if self.appState.sheetType == SheetType.inputNeeded {
                    InputView(viewModel: InputViewModel(appState: self.appState)).environmentObject(self.appState)
                } else {
                    AssemblyCodeEditor(viewModel: AssemblyCodeEditorViewModel(appState: self.appState)).environmentObject(self.appState)
                }
            }
        }
    }
    
    private func assemblyButtonAction() {
        appState.sheetType = .assemblyCodeEditor
        appState.showSheet.toggle()
    }
    
    private func runAction() {
        viewModel.run()
    }
    
    private func stepAction() {
        viewModel.step()
    }
    
    private func resetAction() {
        //        viewModel.reset()
        appState.sheetType = .inputNeeded
        appState.showSheet.toggle()
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
            Text("\(value)")
                .font(.system(size: 12))
        }
    }
}

struct OutboxView: View {
    @Binding var outbox: [Int]
    
    var body: some View {
        VStack {
            Text("outboxTitle")
            
            // TODO: this really needs to be a scrollable view
            ForEach(outbox, id: \.self) {
                Text("\($0)")
                    .background(Color.gray)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .frame(width: 150, height: 150)
    }
}

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView(viewModel: MainPhoneViewModel(appState: AppState()))
    }
}
