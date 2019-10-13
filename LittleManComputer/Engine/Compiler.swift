//
//  Compiler.swift
//  LittleManComputer
//
//  Created by SparrowTek on 8/13/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation

enum CompileError: Error {
    case mailboxOutOfBounds // Mailbox xx is either less than 0 or greater than 99
    //case branchError // Not needed for now
    case invalidAssemblyCode // TODO: make more specific invalid assembly code errors
    case unknownError
}

// interpretedAssemblyCodeLine consists of an oppcode, a leading label optional, trailing label optional, and an optional int value.
struct InterpretedAssemblyCodeLine {
    var opCode: String
    var leadingLabel: String?
    var trailingLabel: String?
    var value: Int?
}

class Compiler {
    private var assemblyCodeRegisterCount = 0
    private var leadingLabelDictionary = [String : Int]() // keeps track of all registers that are associated with a leading label
    
    
    func assembleIntoRam(_ code: String, completion: @escaping ((_ result: Result<Data, CompileError>) -> Void)) {
        // create array of lines
        let codeWithoutLeadingAndTrailingWhiteSpace = code.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()
        let lineArray = codeWithoutLeadingAndTrailingWhiteSpace.components(separatedBy: .newlines)
    }
    
    // parse the assembly code that was input by the user and load the registers with the proper value
        // check that the assembly code entered is valid and can compile into the memory registers
        func compile(_ code: String, completion: @escaping ((_ error: CompileError?) -> Void)) {

//            resetRegisters()

            let codeWithoutLeadingAndTrailingWhiteSpace = code.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased() // remove whitespace
            let lineArray = codeWithoutLeadingAndTrailingWhiteSpace.components(separatedBy: .newlines) // create an array of strings. this seperates each assembly command into its own string
            assemblyCodeRegisterCount = 0
            leadingLabelDictionary = [ : ]

            do {
                let interpretedLines = try createInterpretedLinesArray(with: lineArray) // interpret each line in linesArray and get an array of type InterpretedAssemblyCodeLine (see Typealias at begining of this file)
                trackLabels(for: interpretedLines) // populate leadingLabelDictionary for each InterpretedAssemblyCodeLine object that has a label
                try setRegistersFromInterpretedAssemblyCodeLineArray(interpretedLines, arrayCount: lineArray.count) // set each register
                completion(nil)
    //            delegate?.compileSuccess()
            } catch let error as CompileError {
                completion(error)
            } catch {
                completion(CompileError.unknownError)
            }
        }
    
    // MARK: Methods to help load registers from assembly code
    private func setRegistersFromInterpretedAssemblyCodeLineArray(_ interpretedLines: [InterpretedAssemblyCodeLine], arrayCount: Int) throws {
        do {
            for index in 0..<arrayCount {
//                registers[index].value = try getRegisterValue(for: interpretedLines[index])
            }
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func createInterpretedLinesArray(with linesArray: [String]) throws -> [InterpretedAssemblyCodeLine] {
        var interpretedLines = [InterpretedAssemblyCodeLine]()
        
        for line in linesArray {
            
            do {
                try interpretedLines.append(interpretLine(line))
            } catch let error as CompileError {
                throw error
            }
        }
        
        return interpretedLines
    }
    
    private func trackLabels(for assemblyCode: [InterpretedAssemblyCodeLine]) {
        
        for interpretedAssemblyCodeLine in assemblyCode {
            
            if let leadingLabel = interpretedAssemblyCodeLine.leadingLabel {
                leadingLabelDictionary[leadingLabel] = assemblyCodeRegisterCount
            }
            
            assemblyCodeRegisterCount += 1
        }
    }
    
    private func getRegisterValue(for assemblyCode: InterpretedAssemblyCodeLine) throws -> Int16 {
        
        guard let opCode = Opcode(rawValue: assemblyCode.opCode) else {
            throw CompileError.invalidAssemblyCode
        }
        
        if opCode == .data {
            if assemblyCode.leadingLabel != nil, let value = assemblyCode.value {
                return Int16(value)
            } else if assemblyCode.leadingLabel != nil {
                return 0
            } else if let value = assemblyCode.value {
                return Int16(value)
            } else {
                throw CompileError.invalidAssemblyCode
            }
        }
        
        if opCode == .input || opCode == .output || opCode == .halt {
            return Int16(getDigitFromOppCode(opCode))
        }
        
        do {
            let mailbox = try setMailboxWith(trailingLabel: assemblyCode.trailingLabel)
            return Int16(getDigitFromOppCode(opCode) + mailbox)
            
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func setMailboxWith(trailingLabel: String?) throws -> Int {
        
        if let label = trailingLabel, let mailbox = leadingLabelDictionary[label] {
            return mailbox
        }
        else {
            throw CompileError.invalidAssemblyCode
        }
    }
    
    private func getDigitFromOppCode(_ oppCode: Opcode) -> Int {
        
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
        case .input:
            return 901
        case .output:
            return 902
        case .halt, .data:
            return 000
        }
    }
    
    // Interpret the line String and return an InterpretedAssemblyCodeLine object
    // lines can have 3 parts; leading label, code, and trailing label.
    // but each line can have only the code, or code and either a leading label or a trailing label, or have all 3 parts
    private func interpretLine(_ line: String) throws -> InterpretedAssemblyCodeLine {
        let splitLine = line.components(separatedBy: .whitespaces)
        let opCode: String
        var leadingLabel: String?
        var trailingLabel: String?
        var value: Int?
        let count = splitLine.count
        
        switch count {
            
        case 1:
            opCode = splitLine[0]
        case 2:
            let lineOne = splitLine[0]
            let lineTwo = splitLine[1]
            
            if lineOne == "dat" {
                opCode = lineOne
                value = Int(lineTwo)
            } else if lineTwo == "dat" || lineTwo == "hlt" {
                opCode = lineTwo
                leadingLabel = lineOne
            } else {
                opCode = lineOne
                trailingLabel = lineTwo
            }
        case 3:
            leadingLabel = splitLine[0]
            opCode = splitLine[1]
            if opCode == "dat" {
                value = Int(splitLine[2])
            } else {
                trailingLabel = splitLine[2]
            }
        default:
            throw CompileError.invalidAssemblyCode
        }
        
        if opCode == "dat" && value == nil && leadingLabel == nil {
            throw CompileError.invalidAssemblyCode
        }
        
        return InterpretedAssemblyCodeLine(opCode: opCode, leadingLabel: leadingLabel, trailingLabel: trailingLabel, value: value)
    }
    
}
