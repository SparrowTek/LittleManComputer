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
            do {
                state.value.inbox = input
                state.value = try input(for: state.value)
            } catch let error as StateError {
                state.send(completion: .failure(error))
            } catch {
                state.send(completion: .failure(.generic))
            }
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
            state.value = try execute(instruction: instruction, for: state.value)
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
    
    private func execute(instruction: Instruction, for state: ProgramState) throws -> ProgramState {
        let opcode = instruction.opcode
        let mailbox = instruction.address
        guard mailbox >= 0 && mailbox <= 99 else { throw StateError.mailboxOutOfBounds }
        
        
        switch opcode {
        case .add:
            return add(mailbox: mailbox, for: state)
        case .subtract:
            return subtract(mailbox: mailbox, for: state)
        case .store:
            return store(mailbox: mailbox, for: state)
        case .load:
            return load(mailbox: mailbox, for: state)
        case .branch:
            return branch(mailbox: mailbox, for: state)
        case .branchIfZero:
            return branchIfZero(mailbox: mailbox, for: state)
        case .branchIfPositive:
            return branchIfPositive(mailbox: mailbox, for: state)
        case .input:
            do {
                return try input(for: state)
            } catch let error as StateError {
                throw error
            }
        case .output:
            return output(for: state)
        case .halt:
            return halt(for: state)
        case .data:
            throw StateError.generic
        }
    }
    
    private func resetRegistersCurrentlyBeingEvaluated() {
        state.value.registersCurrentlyBeingEvaluated = [ : ]
    }
    
    private func add(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        let accumulator = state.accumulator
        let registerValue = state.registers[mailbox]
        
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.accumulator += registerValue
        ogState.programCounter += 1
        let formatString = NSLocalizedString("ADD_STATEMENT", comment: "")
        ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, accumulator, mailbox, registerValue))
        return ogState
    }
    
    private func subtract(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        let accumulator = state.accumulator
        let registerValue = state.registers[mailbox]
        
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.accumulator -= registerValue
        ogState.programCounter += 1
        let formatString = NSLocalizedString("SUBTRACT_STATEMENT", comment: "")
        ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, registerValue, mailbox, accumulator))
        return ogState
    }
    
    private func store(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.registersCurrentlyBeingEvaluated[mailbox] = true
        ogState.registers[mailbox] = ogState.accumulator
        ogState.programCounter += 1
        let formatString = NSLocalizedString("STORE_STATEMENT", comment: "")
        ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, ogState.accumulator, mailbox))
        return ogState
    }
    
    private func load(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.registersCurrentlyBeingEvaluated[mailbox] = true
        ogState.accumulator = ogState.registers[mailbox]
        ogState.programCounter += 1
        let formatString = NSLocalizedString("LOAD_STATEMENT", comment: "")
        ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox, ogState.registers[mailbox]))
        return ogState
    }
    
    private func branch(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.programCounter = mailbox
        let formatString = NSLocalizedString("BRANCH_STATEMENT", comment: "")
        ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox))
        return ogState
    }
    
    private func branchIfZero(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        if ogState.accumulator == 0 {
            ogState.programCounter = mailbox
            let formatString = NSLocalizedString("BRANCH_IF_ZERO_TRUE_STATEMENT", comment: "")
            ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox))
        } else {
            ogState.programCounter += 1
            ogState.printStatement = LocalizedStringKey(NSLocalizedString("BRANCH_IF_ZERO_FALSE_STATEMENT", comment: ""))
        }
        
        return ogState
    }
    
    private func branchIfPositive(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        if ogState.accumulator >= 0 {
            ogState.programCounter = mailbox
            let formatString = NSLocalizedString("BRANCH_IF_POSITIVE_TRUE_STATEMENT", comment: "")
            ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, mailbox))
        } else {
            ogState.programCounter += 1
            ogState.printStatement = LocalizedStringKey(NSLocalizedString("BRANCH_IF_POSITIVE_FALSE_STATEMENT", comment: ""))
        }
        
        return ogState
    }
    
    private func input(for state: ProgramState) throws -> ProgramState {
        guard let inbox = state.inbox else { throw StateError.needInput }
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.accumulator = inbox
        ogState.inbox = nil
        ogState.programCounter += 1
        ogState.printStatement = LocalizedStringKey(NSLocalizedString("INPUT_STATEMENT", comment: ""))
        return ogState
    }
    
    private func output(for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.outbox.append(ogState.accumulator)
        ogState.programCounter += 1
        let formatString = NSLocalizedString("OUTPUT_STATEMENT", comment: "")
        ogState.printStatement = LocalizedStringKey(String.localizedStringWithFormat(formatString, ogState.accumulator))
        return ogState
    }
    
    private func halt(for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registersCurrentlyBeingEvaluated[ogState.programCounter] = true
        ogState.printStatement = LocalizedStringKey(NSLocalizedString("HALT_STATEMENT", comment: ""))
        return ogState
    }
}
