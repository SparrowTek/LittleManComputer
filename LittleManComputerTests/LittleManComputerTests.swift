//
//  LittleManComputerTests.swift
//  LittleManComputerTests
//
//  Created by Thomas J. Rademaker on 8/13/19.
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
    
    func createTestState() -> State {
        let registers = [506, 107, 902, 108, 902, 000, 001, 010, 003, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000,
        000, 000, 000, 000, 000, 000, 000, 000, 000, 000]
        
        return State(registers: registers)
    }
    
    // MARK: Compiler Tests
    func testCompile() {
        do {
            let code = """
                       LDA ONE
                       ADD TEN
                       OUT
                       ADD THREE
                       OUT
                       HLT
                       ONE DAT 001
                       TEN DAT 010
                       THREE DAT 003
                       """
            let testState = createTestState()
            
            let compiler = Compiler()
            let state = try compiler.compile(code)
            
            XCTAssert(state.registers == testState.registers, "STATE: \(state)")
        } catch let error {
            XCTAssert(false, "Error: \(error)")
        }
    }
    
    // MARK: Virtual Machine Tests
    func testVirtualMachineStep() {
        
        let state = createTestState()
        let vm = VirtualMachine(state: state)
        
        let expectation = XCTestExpectation(description: "expect State to change from the Virtual Machine \"Step\"")
        let cancelable = vm.state.sink(receiveCompletion: { completion in
            expectation.fulfill()
        }, receiveValue: { state in
            expectation.fulfill()
        })
        
        vm.step()
        wait(for: [expectation], timeout: 3)
        XCTAssert(vm.state.value.programCounter == 1, "Program counter should have incremented to 1. \n program counter: \(vm.state.value.programCounter)")
        let printStatement = "Load the value in register 6 (1) into the accumulator"
        XCTAssert(vm.state.value.printStatement == printStatement, "wrong print statement: \n \(vm.state.value.printStatement)")
        XCTAssertNotNil(cancelable, "The subscription should not be nil")
    }
    
    func testVirtualMachineRun() {
        let state = createTestState()
        let vm = VirtualMachine(state: state)
        var count = 0
        let expectation = XCTestExpectation(description: "program complete")
        let cancelable = vm.state.sink(receiveCompletion: { _ in },
                                       receiveValue: { state in
                                        count += 1
                                        if count >= 7 {
                                            expectation.fulfill()
                                        }
        })
        vm.run(speed: 0.1)
        wait(for: [expectation], timeout: 2)

        let executedState = vm.state.value
        XCTAssertNotNil(cancelable, "The subscription should not be nil")
        XCTAssertEqual(executedState.programCounter, 5, "Program Counter: \(executedState.programCounter)")
        XCTAssertEqual(executedState.printStatement, "Program Complete", "Print Statement: \(executedState.printStatement)")
        XCTAssertEqual(executedState.outbox, [11, 14], "Outbox: \(executedState.outbox)")
        XCTAssertEqual(executedState.accumulator, 14, "Accumulator: \(executedState.accumulator)")
        XCTAssertNil(executedState.inbox, "Inbox should be nil but is \(String(describing: executedState.inbox))")
    }

}
