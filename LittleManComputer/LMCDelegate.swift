//
//  LMCDelegate.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

protocol LMCDelegate: class {
    func setOutbox(_ outboxValue: Int) // set outbox in the UI when an output oppcode is triggered 
    func setCurrentRegisterBeingEvaluated(_ register: Int) // set the current register so the UI can be updated accordingly
}
