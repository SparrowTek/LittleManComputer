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
    private let vm: VirtualMachine
    private var cancelable: AnyCancellable?
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        vm = VirtualMachine(state: appState.programState)
        subscribeToState()
    }
    
    private func subscribeToState() {
        cancelable = vm.state.sink(receiveCompletion: { completion in
            print("completion: \n\(completion)")
        }, receiveValue: { state in
            print(state)
            self.appState.programState = state
        })
    }
    
    func run() {
        vm.run(speed: 1)
    }
    
    func step() {
        vm.step()
    }
    
    func reset() {
        #warning("implement reset()")
    }
}
