//
//  MainPhoneViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/5/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine

class MainPhoneViewModel {
    private var cancelable: AnyCancellable?
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        subscribeToState()
    }
    
    private func subscribeToState() {
        cancelable = appState.virtualMachine.state.sink(receiveCompletion: { completion in
            print("completion: \n\(completion)")
        }, receiveValue: { state in
            print(state)
            self.appState.programState = state
        })
    }
    
    func run() {
        appState.virtualMachine.run(speed: 1)
    }
    
    func step() {
        appState.virtualMachine.step()
    }
    
    func reset() {
        #warning("implement reset()")
    }
}
