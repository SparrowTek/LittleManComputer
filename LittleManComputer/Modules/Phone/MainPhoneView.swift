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
                        StateRepresentationView(title: "programCounter", value: "3")
                        StateRepresentationView(title: "accumulator", value: "4")
                    }
                    Spacer()
                    OutboxView()
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
    private var value = ""
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
            Text(value)
                .font(.system(size: 12))
        }
    }
}

struct OutboxView: View {
    var body: some View {
        VStack {
            Text("outboxTitle")
            Text("23")
                .background(Color.gray)
                .foregroundColor(.white)
            
            Spacer()
        }
        .frame(width: 150, height: 150)
    }
}

//struct MainPhoneViewButtons: View {
//    var body: some View {
//        VStack {
//
//        }
//    }


//}

/**
 Program counter
 input alert
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
        MainPhoneView(viewModel: MainPhoneViewModel())
    }
}
