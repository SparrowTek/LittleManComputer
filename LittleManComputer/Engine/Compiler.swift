//
//  Compiler.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 8/13/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import Foundation

enum CompileError: Error {
    case invalidAssemblyCode // TODO: make more specific invalid assembly code errors
    case intExpected
}

class Compiler {
    
    struct InterpretedAssemblyCodeLine {
        var opCode: String
        var leadingLabel: String? = nil
        var trailingLabel: String? = nil
        var value: Int? = nil
    }
    
    // parse the assembly code that was input by the user and load the registers with the proper value
    // check that the assembly code entered is valid and can compile into the memory registers
    func compile(_ code: String) throws -> ProgramState {
        
        do {
            let linesOfCode = createStringArray(from: code, seperatedBy: .newlines)
            let interpretedLinesOfCode = try interpretLinesOfCode(linesOfCode)
            return try stateFromInterpretedCode(interpretedLinesOfCode)
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func stateFromInterpretedCode(_ interpretedLinesOfCode: [InterpretedAssemblyCodeLine]) throws -> ProgramState {
        do {
            let leadingLabels = trackLabels(for: interpretedLinesOfCode)
            let registers = try setRegistersFromInterpretedAssemblyCodeLineArray(interpretedLinesOfCode, leadingLabels: leadingLabels)
            return ProgramState(registers: registers)
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func createStringArray(from code: String, seperatedBy characterSet: CharacterSet) -> [String] {
        let codeWithoutLeadingAndTrailingWhiteSpace = code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return codeWithoutLeadingAndTrailingWhiteSpace.components(separatedBy: characterSet)
    }
    
    private func interpretLinesOfCodeWith1Arg(_ args: [String]) throws -> InterpretedAssemblyCodeLine {
        let opCode = args[0]
        try testForValidCodeLine(opCode: opCode, value: nil, leadingLabel: nil)
        return InterpretedAssemblyCodeLine(opCode: opCode)
    }
    
    private func interpretLinesOfCodeWith2Args(_ args: [String]) throws -> InterpretedAssemblyCodeLine {
        let arg1 = args[0]
        let arg2 = args[1]
        let opCode: String
        var value: Int?
        var leadingLabel: String?
        var trailingLabel: String?
        
        if arg1 == "dat" {
            opCode = arg1
            guard let argAsInt = Int(arg2) else { throw CompileError.intExpected }
            value = argAsInt
        } else if arg2 == "dat" || arg2 == "hlt" {
            opCode = arg2
            leadingLabel = arg1
        } else {
            opCode = arg1
            trailingLabel = arg2
        }
        
        try testForValidCodeLine(opCode: opCode, value: value, leadingLabel: leadingLabel)
        return InterpretedAssemblyCodeLine(opCode: opCode, leadingLabel: leadingLabel, trailingLabel: trailingLabel, value: value)
    }
    
    private func interpretLinesOfCodeWith3Args(_ args: [String]) throws -> InterpretedAssemblyCodeLine {
        var value: Int?
        var trailingLabel: String?
        let leadingLabel = args[0]
        let opCode = args[1]
        
        if opCode == "dat" {
            guard let argAsInt = Int(args[2]) else { throw CompileError.intExpected }
            value = argAsInt
        } else {
            trailingLabel = args[2]
        }
        
        try testForValidCodeLine(opCode: opCode, value: value, leadingLabel: leadingLabel)
        return InterpretedAssemblyCodeLine(opCode: opCode, leadingLabel: leadingLabel, trailingLabel: trailingLabel, value: value)
    }
    
    private func testForValidCodeLine(opCode: String, value: Int?, leadingLabel: String?) throws {
        if opCode == "dat" && value == nil && leadingLabel == nil {
            throw CompileError.invalidAssemblyCode
        }
    }
    
    /** lines can have 3 parts; leading label, code, and trailing label.
 but each line can have only the code, or code and either a leading label or a trailing label, or have all 3 parts */
    private func interpretLinesOfCode(_ linesOfCode: [String]) throws -> [InterpretedAssemblyCodeLine] {
        var interpretedLines = [InterpretedAssemblyCodeLine]()
        
        for line in linesOfCode {
            let args = createStringArray(from: line, seperatedBy: .whitespaces)
            
            switch args.count {
            case 1:
                try interpretedLines.append(interpretLinesOfCodeWith1Arg(args))
            case 2:
                try interpretedLines.append(interpretLinesOfCodeWith2Args(args))
            case 3:
                try interpretedLines.append(interpretLinesOfCodeWith3Args(args))
            default:
                throw CompileError.invalidAssemblyCode
            }
        }
        
        return interpretedLines
    }
    
    private func trackLabels(for code: [InterpretedAssemblyCodeLine]) -> [String : Int] {
        var registerCount = 0
        var leadingLabelDictionary = [String : Int]()
        for interpretedAssemblyCodeLine in code {
            
            if let leadingLabel = interpretedAssemblyCodeLine.leadingLabel {
                leadingLabelDictionary[leadingLabel] = registerCount
            }
            
            registerCount += 1
        }
        
        return leadingLabelDictionary
    }
    
    private func convertCodeStringToOppCode(code: String) throws -> Opcode {
        
        switch code {
        case "add":
            return .add
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
    
    // MARK: Methods to help load registers from assembly code
    private func setRegistersFromInterpretedAssemblyCodeLineArray(_ interpretedLines: [InterpretedAssemblyCodeLine], leadingLabels: [String : Int]) throws -> [Register] {
        
        do {
            var registers = [Register](repeating: 000, count: 100)
            
            for index in 0..<interpretedLines.count {
                registers[index] = try getRegisterValue(for: interpretedLines[index], leadingLabels: leadingLabels)
            }
            
            return registers
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func getRegisterValue(for assemblyCode: InterpretedAssemblyCodeLine, leadingLabels: [String : Int]) throws -> Int {
        
        guard let opCode = Opcode(rawValue: assemblyCode.opCode) else {
            throw CompileError.invalidAssemblyCode
        }
        
        if opCode == .data {
            if assemblyCode.leadingLabel != nil, let value = assemblyCode.value {
                return Int(value)
            } else if assemblyCode.leadingLabel != nil {
                return 0
            } else if let value = assemblyCode.value {
                return Int(value)
            } else {
                throw CompileError.invalidAssemblyCode
            }
        }
        
        if opCode == .input || opCode == .output || opCode == .halt {
            return Int(getDigitFromOpCode(opCode))
        }
        
        do {
            let mailbox = try setMailboxWith(trailingLabel: assemblyCode.trailingLabel, leadingLabel: leadingLabels)
            return Int(getDigitFromOpCode(opCode) + mailbox)
            
        } catch let error as CompileError {
            throw error
        }
    }
    
    private func setMailboxWith(trailingLabel: String?, leadingLabel: [String : Int]) throws -> Int {
        
        if let label = trailingLabel, let mailbox = leadingLabel[label] {
            return mailbox
        }
        else {
            throw CompileError.invalidAssemblyCode
        }
    }
    
    private func getDigitFromOpCode(_ opCode: Opcode) -> Int {
        
        switch opCode {
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
}
