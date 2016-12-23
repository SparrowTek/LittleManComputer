//
//  LittleManComputerModel.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

import Foundation

// enum of Oppcodes used in LMC assembly language
enum Oppcode {
    case add, subtract, store, load, branch, branchIfZero, branchIfPositive, input, output, halt
}

// Error enum
enum CompileError: Error {
    case mailboxOutOfBounds // Mailbox xx is either less than 0 or greater than 99
    //case branchError // Not needed for now
    case invalidAssemblyCode // TODO: make more specific invalid assembly code errors
    case unknownError
}

// interpretedRegister consists of an oppcode, a leading label optional, trailing label optional, and an optional int value.
typealias interpretedRegister = (oppCode: String, leadingLabel: String?, trailingLabel: String?, value: Int?)

class LittleManComputerModel {
    
    weak var delegate: LMCDelegate?
    
    private var accumulator = 0
    private var programCounter = 0
    private var outbox = 0
    var inbox = 0
    var inboxSet = false
    
    private var assemblyCodeRegisterCount = 0
    private var leadingLabelDictionary = [String : Int]() // keeps track of all registers that are associated with a leading label
    
    private let registers: Registers!
    
    init(registers: Registers) {
        self.registers = registers
    }
    
    //compiles the data from the next register and executes the command
    func compileAndStep(completion: (_ stepDetail: String?, _ programCounter: Int, _ accumulator: Int, _ needInput: Bool, _ halt: Bool, _ error: CompileError?) -> Void) {
        delegate?.setCurrentRegisterBeingEvaluated(programCounter)
        let registerValue = registers[programCounter] // the register value for the programs current stack position
        
        let oppCode = getOppCode(registerValue: registerValue) // gets the Oppcode for the given register value
        let mailbox = getMailbox(registerValue: registerValue) // gets the mailbox for the given register value
        
        // a user input is needed. execute the completion fuction and return
        if oppCode == Oppcode.input && !inboxSet {
            completion("Enter input", programCounter, accumulator, true, false, nil)
            return
        }
        
        // the program has completed. halt execution
        if oppCode == Oppcode.halt {
            completion("Program Complete", programCounter, accumulator, false, true, nil)
            return
        }
        
        
        do {
            let message = try evaluateRegister(oppCode: oppCode, mailbox: mailbox) // execute the code in the register
            completion(message, programCounter, accumulator, false, false, nil) // call the completion function and pass along the data from the executed code
            
        } catch let error as CompileError {
            completion(nil, programCounter, accumulator, false, false, error)
        } catch {
            completion(nil, programCounter, accumulator, false, false, CompileError.unknownError)
        }
    }
    
    // reset the LMC model
    func reset() {
        inboxSet = false
        accumulator = 0
        programCounter = 0
        inbox = 0
        outbox = 0
    }
    
    // parse the assembly code that was input by the user and load the registers with the proper value
    // check that the assembly code entered is valid and can compile into the memory registers
    func loadRegisters(code: String, completion: ((_ error: CompileError?) -> Void)) {
        
        for index in 0...99 {
            registers[index] = 0 // reset the register data in all registers to '0'
        }
        
        let codeWithoutLeadingAndTrailingWhiteSpace = code.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) // remove whitespace
        let linesArray = splitLines(code: codeWithoutLeadingAndTrailingWhiteSpace.lowercased()) // create an array of strings. this seperates each assembly command into its own string
        assemblyCodeRegisterCount = 0
        leadingLabelDictionary = [ : ]
        
        do {
            let interpretedLines = try createInterpretedLinesArray(linesArray: linesArray) // interpret each line in linesArray and get an array of type interpretedRegister (see Typealias at begining of this file)
            trackLabels(assemblyCode: interpretedLines) // populate leadingLabelDictionary for each interpretedRegister object that has a label
            try setRegistersFrominterpretedRegisterArray(interpretedLines: interpretedLines, arrayCount: linesArray.count) // set each register
            completion(nil)
        } catch let error as CompileError {
            completion(error)
        } catch {
            completion(CompileError.unknownError)
        }
    }
    
    // return the Oppcode from the Int register value parameter
    private func getOppCode(registerValue: Int) -> Oppcode {
        let oppCode = (registerValue - (registerValue % 100)) / 100
        
        switch oppCode {
        case 1:
            return Oppcode.add
        case 2:
            return Oppcode.subtract
        case 3:
            return Oppcode.store
        case 5:
            return Oppcode.load
        case 6:
            return Oppcode.branch
        case 7:
            return Oppcode.branchIfZero
        case 8:
            return Oppcode.branchIfPositive
        case 9:
            if registerValue == 901 {
                return Oppcode.input
            }
            return Oppcode.output
        default:
            return Oppcode.halt
        }
    }
    
    // returns the mailbox Int based on the register value Int parameter
    private func getMailbox(registerValue: Int) -> Int {
        return registerValue % 100
    }
    
    // given the Oppcode and the mailbox(Int) return a String about what action has been executed
    private func evaluateRegister(oppCode: Oppcode, mailbox: Int) throws -> String {
        
        guard mailbox >= 0 && mailbox <= 99 && programCounter >= 0 && programCounter <= 99 else {
            throw CompileError.mailboxOutOfBounds
        }
        
        let returnString: String
        
        switch oppCode {
        case .add:
            let accumulatorCopy = accumulator
            accumulator += registers[mailbox]
            returnString = "Add \(accumulatorCopy) from the accumulator to the value in register \(mailbox) (\(registers[mailbox]))"
        case .subtract:
            accumulator -= registers[mailbox]
            returnString = "Subtract \(registers[mailbox]) in register \(mailbox) from the accumulator value (\(accumulator))"
        case .store:
            registers[mailbox] = accumulator // TODO: update register value
            returnString = "Store the accumulator value \(accumulator) in register \(mailbox)"
        case .load:
            accumulator = registers[mailbox]
            returnString = "Load the value in register \(mailbox) (\(registers[mailbox])) into the accumulator"
        case .branch:
            programCounter = mailbox
            return "Branch: change the program counter to the value in register \(mailbox)"
        case .branchIfZero:
            
            if accumulator == 0 {
                programCounter = mailbox
                return "Branch if zero: Accumulator == 0 is true. Program counter sets to \(mailbox)"
            }
            
            returnString = "Branch if zero: The accumulator != 0. Do not branch; increment program counter"
        case .branchIfPositive:
            
            if accumulator >= 0 {
                programCounter = mailbox
                return "Branch if positive: Accumulator >= 0 is true. Program counter sets to \(mailbox)"
            }
            
            returnString = "Branch if positive: Accumulator is not possitive. Do not branch"
        case .input:
            inboxSet = false
            accumulator = inbox
            returnString = "Input"
        case .output:
            outbox = accumulator
            DispatchQueue.main.async(execute: {
                self.delegate?.setOutbox(self.outbox)
            })
            
            returnString = "Output: output the value in the accumulator, \(accumulator) into the output box"
        case .halt: // I Should never actually get here
            returnString = "Halt"
        }
        
        programCounter += 1
        return returnString
    }
    
    // MARK: Methods to help load registers from assembly code
    private func setRegistersFrominterpretedRegisterArray(interpretedLines: [interpretedRegister], arrayCount: Int) throws {
        do {
            for index in 0..<arrayCount {
                registers[index] = try getRegisterValue(assemblyCode: interpretedLines[index])
            }
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func createInterpretedLinesArray(linesArray: [String]) throws -> [interpretedRegister] {
        var interpretedLines = [interpretedRegister]()
        
        for line in linesArray {
            
            do {
                try interpretedLines.append(interpretLine(line: line))
            } catch let error as CompileError {
                throw error
            }
        }
        
        return interpretedLines
    }
    
    private func trackLabels(assemblyCode: [interpretedRegister]) {
        
        for interpretedRegister in assemblyCode {
            
            if let leadingLabel = interpretedRegister.leadingLabel {
                leadingLabelDictionary[leadingLabel] = assemblyCodeRegisterCount
            }
            
            assemblyCodeRegisterCount += 1
        }
    }
    
    private func getRegisterValue(assemblyCode: interpretedRegister) throws -> Int {
        
        if assemblyCode.oppCode == "dat" {
            if assemblyCode.leadingLabel != nil && assemblyCode.value != nil {
                return assemblyCode.value!
            } else if assemblyCode.leadingLabel != nil {
                return 0
            } else {
                return assemblyCode.value!
            }
        }
        
        do {
            let oppCode = try convertCodeStringToOppCode(code: assemblyCode.oppCode)
            
            
            if oppCode == .input {
                return 901
            } else if oppCode == .output {
                return 902
            } else if oppCode == .halt {
                return 000
            }
            
            let mailbox = try setMailbox(trailingLabel: assemblyCode.trailingLabel)
            return getDigitFromOppCode(oppCode: oppCode) + mailbox
            
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func setMailbox(trailingLabel: String?) throws -> Int {
        
        if let label = trailingLabel, let mailbox = leadingLabelDictionary[label] {
            return mailbox
        }
        else {
            throw CompileError.invalidAssemblyCode
        }
    }
    
    private func getDigitFromOppCode(oppCode: Oppcode) -> Int {
        
        switch oppCode {
        case .add:
            return 100
        case .subtract:
            return 200
        case .store:
            return 300
        case .load:
            return 500
        case .branch:
            return 600
        case .branchIfZero:
            return 700
        case .branchIfPositive:
            return 800
        case .input, .output:
            return 900
        case .halt:
            return 000
        }
    }
    
    // Interpret the line String and return an interpretedRegister object
    // lines can have 3 parts; leading label, code, and trailing label.
    // but each line can have only the code, or code and either a leading label or a trailing label, or have all 3 parts
    private func interpretLine(line: String) throws -> interpretedRegister {
        let splitLine = line.components(separatedBy: .whitespaces)//.flatMap(String.init)
        let code: String
        var leadingLabel: String?
        var trailingLabel: String?
        var value: Int?
        let count = splitLine.count
        
        switch count {
            
        case 1:
            code = splitLine[0]
        case 2:
            let lineOne = splitLine[0]
            let lineTwo = splitLine[1]
            
            if lineOne == "dat" {
                code = lineOne
                value = Int(lineTwo)
            } else if lineTwo == "dat" || lineTwo == "hlt" {
                code = lineTwo
                leadingLabel = lineOne
            } else {
                code = lineOne
                trailingLabel = lineTwo
            }
        case 3:
            leadingLabel = splitLine[0]
            code = splitLine[1]
            if code == "dat" {
                value = Int(splitLine[2])
            } else {
                trailingLabel = splitLine[2]
            }
        default:
            throw CompileError.invalidAssemblyCode
        }
        
        if code == "dat" && value == nil && leadingLabel == nil {
            throw CompileError.invalidAssemblyCode
        }
        
        return (code, leadingLabel, trailingLabel, value)
    }
    
    private func convertCodeStringToOppCode(code: String) throws -> Oppcode {
        
        switch code {
        case "add":
            return Oppcode.add
        case "sub":
            return .subtract
        case "sta":
            return .store
        case "lda":
            return .load
        case "bra":
            return .branch
        case "brz":
            return .branchIfZero
        case "brp":
            return .branchIfPositive
        case "inp":
            return .input
        case "out":
            return .output
        case "hlt":
            return .halt
        default:
            throw CompileError.invalidAssemblyCode
        }
    }
    
    private func splitLines(code: String) -> [String] {
        return code.components(separatedBy: .newlines)//.flatMap(String.init)
    }
}
