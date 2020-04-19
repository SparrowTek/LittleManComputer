//
//  VirtualMachine.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 8/13/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine

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
            state.value = try execute(instruction: instruction, for: state.value)
            #warning("the program is not halting. Program complete goes forever...")
        } catch let error as StateError {
            state.send(completion: .failure(error))
        } catch {
            state.send(completion: .failure(.generic))
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
    
    private func add(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        let accumulator = state.accumulator
        let registerValue = state.registers[mailbox]
        
        ogState.accumulator += registerValue
        ogState.programCounter += 1
        ogState.printStatement = "Add \(accumulator) from the accumulator to the value in register \(mailbox) (\(registerValue))"
        return ogState
    }
    
    private func subtract(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        let accumulator = state.accumulator
        let registerValue = state.registers[mailbox]
        
        ogState.accumulator -= registerValue
        ogState.programCounter += 1
        ogState.printStatement = "Subtract \(registerValue) in register \(mailbox) from the accumulator value (\(accumulator))"
        return ogState
    }
    
    private func store(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.registers[mailbox] = ogState.accumulator
        ogState.programCounter += 1
        ogState.printStatement = "Store the accumulator value \(ogState.accumulator) in register \(mailbox)"
        return ogState
    }
    
    private func load(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.accumulator = ogState.registers[mailbox]
        ogState.programCounter += 1
        ogState.printStatement = "Load the value in register \(mailbox) (\(ogState.registers[mailbox])) into the accumulator"
        return ogState
    }
    
    private func branch(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.programCounter = mailbox
        ogState.printStatement = "Branch: change the program counter to the value in register \(mailbox)"
        return ogState
    }
    
    private func branchIfZero(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        
        if ogState.accumulator == 0 {
            ogState.programCounter = mailbox
            ogState.printStatement = "Branch if zero: Accumulator == 0 is true. Program counter sets to \(mailbox)"
        } else {
            ogState.programCounter += 1
            ogState.printStatement = "Branch if zero: The accumulator != 0. Do not branch; increment program counter"
        }
        
        return ogState
    }
    
    private func branchIfPositive(mailbox: Mailbox, for state: ProgramState) -> ProgramState {
        var ogState = state
        
        if ogState.accumulator >= 0 {
            ogState.programCounter = mailbox
            ogState.printStatement = "Branch if positive: Accumulator >= 0 is true. Program counter sets to \(mailbox)"
        } else {
            ogState.programCounter += 1
            ogState.printStatement = "Branch if positive: Accumulator is not possitive. Do not branch"
        }
        
        return ogState
    }
    
    private func input(for state: ProgramState) throws -> ProgramState {
        guard let inbox = state.inbox else { throw StateError.needInput }
        var ogState = state
        ogState.accumulator = inbox
        ogState.programCounter += 1
        ogState.printStatement = "Input"
        return ogState
    }
    
    private func output(for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.outbox.append(ogState.accumulator)
        ogState.programCounter += 1
        ogState.printStatement = "Output: output the value in the accumulator, \(ogState.accumulator) into the output box"
        return ogState
    }
    
    private func halt(for state: ProgramState) -> ProgramState {
        var ogState = state
        ogState.printStatement = "Program Complete"
        return ogState
    }
}
