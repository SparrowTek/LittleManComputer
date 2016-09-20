//
//  Registers.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

class Registers {
    
    var registers = [Int](repeatElement(000, count: 100))
    
    subscript(index : Int) -> Int {
        
        get {
            return registers[index]
        }
        set {
            registers[index] = newValue
        }
    }
}
