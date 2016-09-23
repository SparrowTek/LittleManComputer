//
//  LittleManComputerModel.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

import Foundation

enum Oppcode {
    case add, subtract, store, load, branch, branchIfZero, branchIfPositive, input, output, halt
}

enum CompileError: Error {
    case mailboxOutOfBounds // Mailbox xx is either less than 0 or greater than 99
    case branchError // Negative flag set to true
    case invalidAssemblyCode // TODO: make more specific invalid assembly code errors
    case unknownError
}

typealias interpretedRegister = (oppCode: String, leadingLabel: String?, trailingLabel: String?, value: Int?)

class LittleManComputerModel {
    
    weak var delegate: LMCDelegate?
    
    private var negativeFlag = false
    
    private var accumulator = 0
    private var programCounter = 0
    private var outbox = 0
    var inbox = 0
    var inboxSet = false
    
    private var assemblyCodeRegisterCount = 0
    private var leadingLabelDictionary = [String : Int]()
    
    private let registers: Registers!
    
    init(registers: Registers) {
        self.registers = registers
    }
    
    func compileAndStep(completion: (_ stepDetail: String?, _ programCounter: Int, _ accumulator: Int, _ needInput: Bool, _ halt: Bool, _ error: CompileError?) -> Void) {
        let registerValue = registers[programCounter]
        
        let oppCode = getOppCode(registerValue: registerValue)
        let mailbox = getMailbox(registerValue: registerValue)
        
        if oppCode == Oppcode.input && !inboxSet {
            completion("Enter input", programCounter, accumulator, true, false, nil)
            return
        }
        
        if oppCode == Oppcode.halt {
            completion("Program Complete", programCounter, accumulator, false, true, nil)
            return
        }
        
        
        do {
            let message = try evaluateRegister(oppCode: oppCode, mailbox: mailbox)
            completion(message, programCounter, accumulator, false, false, nil)
            
        } catch let error as CompileError {
            //halt = true
            completion(nil, programCounter, accumulator, false, false, error)
        } catch {
            //halt = true
            completion(nil, programCounter, accumulator, false, false, CompileError.unknownError)
        }
    }
    
    func reset() {
        negativeFlag = false
        inboxSet = false
        accumulator = 0
        programCounter = 0
        inbox = 0
        outbox = 0
    }
    
    func loadRegisters(code: String, completion: ((_ error: CompileError?) -> Void)) {
        let linesArray = splitLines(code: code.lowercased())
        assemblyCodeRegisterCount = 0
        leadingLabelDictionary = [ : ]
        
        do {
            let interpretedLines = try createInterpretedLinesArray(linesArray: linesArray)
            trackLabels(assemblyCode: interpretedLines)
            try setRegistersFrominterpretedRegisterArray(interpretedLines: interpretedLines, arrayCount: linesArray.count)
            completion(nil)
        } catch let error as CompileError {
            completion(error)
        } catch {
            completion(CompileError.unknownError)
        }
    }
    
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
    
    private func getMailbox(registerValue: Int) -> Int {
        return registerValue % 100
    }
    
    private func evaluateRegister(oppCode: Oppcode, mailbox: Int) throws -> String {
        
        guard mailbox >= 0 && mailbox <= 99 && programCounter >= 0 && programCounter <= 99 else {
            throw CompileError.mailboxOutOfBounds
        }
        
        let returnString: String
        
        switch oppCode {
        case .add:
            let accumulatorCopy = accumulator
            accumulator += registers[mailbox]
            returnString = "Add \(accumulatorCopy) from the accumulator to the value in register \(mailbox); \(registers[mailbox])"
        case .subtract:
            accumulator -= registers[mailbox]
            returnString = "Subtract \(registers[mailbox]) in register \(mailbox) from the accumulator value; \(accumulator)"
        case .store:
            registers[mailbox] = accumulator
            returnString = "Store the accumulator value \(accumulator) in register \(mailbox)"
        case .load:
            accumulator = registers[mailbox]
            returnString = "Load the value in register \(mailbox); \(registers[mailbox]) into the accumulator"
        case .branch:
            programCounter = registers[mailbox]
            return "Branch: change the program counter to the value in register \(mailbox)"
        case .branchIfZero:
            
            if accumulator == 0 && !negativeFlag {
                programCounter = registers[mailbox]
                return "Branch if zero: If accumulator == 0 change the program counter to the value in register \(mailbox)"
            } else {
                throw CompileError.branchError
            }
            
        case .branchIfPositive:
            
            if accumulator >= 0 && !negativeFlag {
                programCounter = registers[mailbox]
                return "branch if positive: If accumulator >= 0 change the program counter to the value in register \(mailbox)"
            } else {
                throw CompileError.branchError
            }
            
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
        
        if accumulator < 0 || accumulator > 999 {
            negativeFlag = true
        }
        else {
            negativeFlag = false
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
            
            
            if oppCode == Oppcode.input {
                return 901
            } else if oppCode == Oppcode.output {
                return 902
            } else if oppCode == Oppcode.halt {
                return 000
            }
            
            let mailbox = try setMailbox(trailingLabel: assemblyCode.trailingLabel)
            
            return (getDigitFromOppCode(oppCode: oppCode) * 100) + mailbox
            
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
            return 1
        case .subtract:
            return 2
        case .store:
            return 3
        case .load:
            return 5
        case .branch:
            return 6
        case .branchIfZero:
            return 7
        case .branchIfPositive:
            return 8
        case .input, .output:
            return 9
        case .halt:
            return 0
        }
    }
    
    private func interpretLine(line: String) throws -> interpretedRegister {
        //let splitLine = line.characters.split { $0 == " " }.map(String.init)
        let splitLine = line.components(separatedBy: .whitespaces).flatMap(String.init) // TODO: is this correct?
        //let splitLine = line.utf16.split { NSCharacterSet.whitespaceCharacterSet().characterIsMember($0) }.flatMap(String.init)
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
            } else if lineTwo == "dat" {
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
            return Oppcode.subtract
        case "sta":
            return Oppcode.store
        case "lda":
            return Oppcode.load
        case "bra":
            return Oppcode.branch
        case "brz":
            return Oppcode.branchIfZero
        case "brp":
            return Oppcode.branchIfPositive
        case "inp":
            return Oppcode.input
        case "out":
            return Oppcode.output
        case "hlt":
            return Oppcode.halt
        default:
            throw CompileError.invalidAssemblyCode
        }
    }
    
    private func splitLines(code: String) -> [String] {
        //let newLineChars = NSCharacterSet.newlines
        //return code.utf16.split { newLineChars.characterIsMember($0) }.flatMap(String.init) // splits lines
        return code.components(separatedBy: .newlines).flatMap(String.init) // TODO: is this correct?
    }
}
