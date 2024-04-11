//
//  VirtualMachine.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 8/13/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

typealias Mailbox = Int

enum StateError: Error {
    case generic
    case mailboxOutOfBounds
    case needInput
}

class VirtualMachine {
    
    var state: CurrentValueSubject<ProgramState, StateError>
    var input: Int? {
        didSet {
            state.value.inbox = input
            step()
        }
    }
    
    init(state: ProgramState) {
        self.state = CurrentValueSubject<ProgramState, StateError>(state)
    }
    
    func step() {
        do {
            let register = state.value.registers[state.value.programCounter]
            let instruction = getInstruction(for: register)
            resetRegistersCurrentlyBeingEvaluated()
            try execute(instruction: instruction, for: &state.value)
            programShouldCompleteCheck(register: register)
        } catch let error as StateError {
            state.send(completion: .failure(error))
        } catch {
            state.send(completion: .failure(.generic))
        }
    }
    
    private func programShouldCompleteCheck(register: Register) {
        if opcode(for: register) == .halt {
            state.send(completion: .finished)
        }
    }
    
    func run(speed: Double) {
        let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { [weak self] _ in
            self?.step()
        }
        
        let _ = state.sink(receiveCompletion: { _ in
            timer.invalidate()
        }, receiveValue: {_ in })
    }
    
    private func getInstruction(for register: Register) -> Instruction {
        let registerOpcode = opcode(for: register)
        
        switch registerOpcode {
        case .input, .output, .halt:
            return Instruction(opcode: registerOpcode)
        default:
            let mailboxAddress = address(for: register)
            return Instruction(opcode: registerOpcode, address: mailboxAddress)
        }
    }
    
    private func address(for register: Register) -> Mailbox {
        let registerHundredsDigit = (register - (register % 100))
        return register - registerHundredsDigit
    }
    
    private func opcode(for register: Register) -> Opcode {
        let registerFirstDigit = (register - (register % 100)) / 100
        
        switch registerFirstDigit {
        case 1:
            return .add
        case 2:
            return .subtract
        case 3:
            return .store
        case 5:
            return .load
        case 6:
            return .branch
        case 7:
            return .branchIfZero
        case 8:
            return .branchIfPositive
        case 9:
            if register == 901 { return .input }
            return .output
        default:
            return .halt
        }
        
    }
    
    private func execute(instruction: Instruction, for state: inout ProgramState) throws {
        let opcode = instruction.opcode
        let mailbox = instruction.address
        guard mailbox >= 0 && mailbox <= 99 else { throw StateError.mailboxOutOfBounds }
        
        
        switch opcode {
        case .add:
            add(mailbox: mailbox, for: &state)
        case .subtract:
            subtract(mailbox: mailbox, for: &state)
        case .store:
            store(mailbox: mailbox, for: &state)
        case .load:
            load(mailbox: mailbox, for: &state)
        case .branch:
            branch(mailbox: mailbox, for: &state)
        case .branchIfZero:
            branchIfZero(mailbox: mailbox, for: &state)
        case .branchIfPositive:
            branchIfPositive(mailbox: mailbox, for: &state)
        case .input:
            do {
                try input(for: &state)
            } catch let error as StateError {
                throw error
            }
        case .output:
            output(for: &state)
        case .halt:
            halt(for: &state)
        case .data:
            throw StateError.generic
        }
    }
    
    private func resetRegistersCurrentlyBeingEvaluated() {
        state.value.registersCurrentlyBeingEvaluated = [ : ]
    }
    
    private func add(mailbox: Mailbox, for state: inout ProgramState) {
        let accumulator = state.accumulator
        let registerValue = state.registers[mailbox]
        
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.accumulator += registerValue
        state.programCounter += 1
        let formatString = NSLocalizedString("ADD_STATEMENT", comment: "")
        state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, accumulator, mailbox, registerValue))
    }
    
    private func subtract(mailbox: Mailbox, for state: inout ProgramState) {
        let accumulator = state.accumulator
        let registerValue = state.registers[mailbox]
        
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.accumulator -= registerValue
        state.programCounter += 1
        let formatString = NSLocalizedString("SUBTRACT_STATEMENT", comment: "")
        state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, registerValue, mailbox, accumulator))
    }
    
    private func store(mailbox: Mailbox, for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.registersCurrentlyBeingEvaluated[mailbox] = true
        state.registers[mailbox] = state.accumulator
        state.programCounter += 1
        let formatString = NSLocalizedString("STORE_STATEMENT", comment: "")
        state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, state.accumulator, mailbox))
    }
    
    private func load(mailbox: Mailbox, for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.registersCurrentlyBeingEvaluated[mailbox] = true
        state.accumulator = state.registers[mailbox]
        state.programCounter += 1
        let formatString = NSLocalizedString("LOAD_STATEMENT", comment: "")
        state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox, state.registers[mailbox]))
    }
    
    private func branch(mailbox: Mailbox, for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.programCounter = mailbox
        let formatString = NSLocalizedString("BRANCH_STATEMENT", comment: "")
        state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox))
    }
    
    private func branchIfZero(mailbox: Mailbox, for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        if state.accumulator == 0 {
            state.programCounter = mailbox
            let formatString = NSLocalizedString("BRANCH_IF_ZERO_TRUE_STATEMENT", comment: "")
            state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox))
        } else {
            state.programCounter += 1
            state.printStatement = LocalizedStringKey(NSLocalizedString("BRANCH_IF_ZERO_FALSE_STATEMENT", comment: ""))
        }
    }
    
    private func branchIfPositive(mailbox: Mailbox, for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        if state.accumulator >= 0 {
            state.programCounter = mailbox
            let formatString = NSLocalizedString("BRANCH_IF_POSITIVE_TRUE_STATEMENT", comment: "")
            state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox))
        } else {
            state.programCounter += 1
            state.printStatement = LocalizedStringKey(NSLocalizedString("BRANCH_IF_POSITIVE_FALSE_STATEMENT", comment: ""))
        }
    }
    
    private func input(for state: inout ProgramState) throws {
        guard let inbox = state.inbox else { throw StateError.needInput }
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.accumulator = inbox
        state.inbox = nil
        state.programCounter += 1
        state.printStatement = LocalizedStringKey(NSLocalizedString("INPUT_STATEMENT", comment: ""))
    }
    
    private func output(for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.outbox.append(state.accumulator)
        state.programCounter += 1
        let formatString = NSLocalizedString("OUTPUT_STATEMENT", comment: "")
        state.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, state.accumulator))
    }
    
    private func halt(for state: inout ProgramState) {
        state.registersCurrentlyBeingEvaluated[state.programCounter] = true
        state.printStatement = LocalizedStringKey(NSLocalizedString("HALT_STATEMENT", comment: ""))
    }
}
