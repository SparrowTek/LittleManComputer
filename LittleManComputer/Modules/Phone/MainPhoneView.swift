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
    @ObservedObject var viewModel: MainPhoneViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                RegisterCollectionView(programState: $viewModel.programState)
                HStack {
                    ShowAssemblyCodeEditorButton()
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
                            LMCButton(title: "StepButton", height: 30, width: 100, action: stepAction)
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
                        StateRepresentationView(title: "programCounter", value: $viewModel.programState.programCounter)
                        StateRepresentationView(title: "accumulator", value: $viewModel.programState.accumulator)
                    }
                    Spacer()
                    OutboxView(outbox: $viewModel.programState.outbox)
                }
                Spacer()
                Text(viewModel.programState.printStatement)
                    .padding()
                    
                    .padding(.bottom, 16)
                    .navigationBarTitle("navigationBarTitle", displayMode: .inline)
                    .navigationBarItems(trailing: NavBarButtons())
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

/**
 TODO:
 input alert
 assemble into ram button should be in the AssemblyCodeEditor view
 */

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView(viewModel: MainPhoneViewModel())
    }
}
