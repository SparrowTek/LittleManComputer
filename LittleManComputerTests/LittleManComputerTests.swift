//
//  LittleManComputerTests.swift
//  LittleManComputerTests
//
//  Created by SparrowTek on 8/13/19.
//  Copyright © 2019 SparrowTek LLC. All rights reserved.
//

import XCTest
@testable import LittleManComputer

class LittleManComputerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Compiler Tests
    func testCompile() {
        do {
            let code = """
                       LDA ONE
                       ADD TEN
                       OUT
                       INP
                       ADD THREE
                       OUT
                       HLT
                       ONE DAT 001
                       TEN DAT 010
                       THREE DAT 003
                       """
            let registers = [507, 108, 902, 901, 109, 902, 000, 001, 010, 003,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
                             000, 000, 000, 000, 000, 000, 000, 000, 000, 000]
            
            let compiler = Compiler()
            let state = try compiler.compile(code)
            
            XCTAssert(state.ram == registers, "STATE: \(state)")
        } catch let error {
            XCTAssert(false, "Error: \(error)")
        }
    }
    
    // MARK: Virtual Machine Tests

}
