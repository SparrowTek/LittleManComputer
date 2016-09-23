//
//  RegistersViewController.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

import UIKit

class RegistersViewController: UIViewController {
    
    // Register text fields
    @IBOutlet weak var register0: UITextField!
    @IBOutlet weak var register1: UITextField!
    @IBOutlet weak var register2: UITextField!
    @IBOutlet weak var register3: UITextField!
    @IBOutlet weak var register4: UITextField!
    @IBOutlet weak var register5: UITextField!
    @IBOutlet weak var register6: UITextField!
    @IBOutlet weak var register7: UITextField!
    @IBOutlet weak var register8: UITextField!
    @IBOutlet weak var register9: UITextField!
    @IBOutlet weak var register10: UITextField!
    @IBOutlet weak var register11: UITextField!
    @IBOutlet weak var register12: UITextField!
    @IBOutlet weak var register13: UITextField!
    @IBOutlet weak var register14: UITextField!
    @IBOutlet weak var register15: UITextField!
    @IBOutlet weak var register16: UITextField!
    @IBOutlet weak var register17: UITextField!
    @IBOutlet weak var register18: UITextField!
    @IBOutlet weak var register19: UITextField!
    @IBOutlet weak var register20: UITextField!
    @IBOutlet weak var register21: UITextField!
    @IBOutlet weak var register22: UITextField!
    @IBOutlet weak var register23: UITextField!
    @IBOutlet weak var register24: UITextField!
    @IBOutlet weak var register25: UITextField!
    @IBOutlet weak var register26: UITextField!
    @IBOutlet weak var register27: UITextField!
    @IBOutlet weak var register28: UITextField!
    @IBOutlet weak var register29: UITextField!
    @IBOutlet weak var register30: UITextField!
    @IBOutlet weak var register31: UITextField!
    @IBOutlet weak var register32: UITextField!
    @IBOutlet weak var register33: UITextField!
    @IBOutlet weak var register34: UITextField!
    @IBOutlet weak var register35: UITextField!
    @IBOutlet weak var register36: UITextField!
    @IBOutlet weak var register37: UITextField!
    @IBOutlet weak var register38: UITextField!
    @IBOutlet weak var register39: UITextField!
    @IBOutlet weak var register40: UITextField!
    @IBOutlet weak var register41: UITextField!
    @IBOutlet weak var register42: UITextField!
    @IBOutlet weak var register43: UITextField!
    @IBOutlet weak var register44: UITextField!
    @IBOutlet weak var register45: UITextField!
    @IBOutlet weak var register46: UITextField!
    @IBOutlet weak var register47: UITextField!
    @IBOutlet weak var register48: UITextField!
    @IBOutlet weak var register49: UITextField!
    @IBOutlet weak var register50: UITextField!
    @IBOutlet weak var register51: UITextField!
    @IBOutlet weak var register52: UITextField!
    @IBOutlet weak var register53: UITextField!
    @IBOutlet weak var register54: UITextField!
    @IBOutlet weak var register55: UITextField!
    @IBOutlet weak var register56: UITextField!
    @IBOutlet weak var register57: UITextField!
    @IBOutlet weak var register58: UITextField!
    @IBOutlet weak var register59: UITextField!
    @IBOutlet weak var register60: UITextField!
    @IBOutlet weak var register61: UITextField!
    @IBOutlet weak var register62: UITextField!
    @IBOutlet weak var register63: UITextField!
    @IBOutlet weak var register64: UITextField!
    @IBOutlet weak var register65: UITextField!
    @IBOutlet weak var register66: UITextField!
    @IBOutlet weak var register67: UITextField!
    @IBOutlet weak var register68: UITextField!
    @IBOutlet weak var register69: UITextField!
    @IBOutlet weak var register70: UITextField!
    @IBOutlet weak var register71: UITextField!
    @IBOutlet weak var register72: UITextField!
    @IBOutlet weak var register73: UITextField!
    @IBOutlet weak var register74: UITextField!
    @IBOutlet weak var register75: UITextField!
    @IBOutlet weak var register76: UITextField!
    @IBOutlet weak var register77: UITextField!
    @IBOutlet weak var register78: UITextField!
    @IBOutlet weak var register79: UITextField!
    @IBOutlet weak var register80: UITextField!
    @IBOutlet weak var register81: UITextField!
    @IBOutlet weak var register82: UITextField!
    @IBOutlet weak var register83: UITextField!
    @IBOutlet weak var register84: UITextField!
    @IBOutlet weak var register85: UITextField!
    @IBOutlet weak var register86: UITextField!
    @IBOutlet weak var register87: UITextField!
    @IBOutlet weak var register88: UITextField!
    @IBOutlet weak var register89: UITextField!
    @IBOutlet weak var register90: UITextField!
    @IBOutlet weak var register91: UITextField!
    @IBOutlet weak var register92: UITextField!
    @IBOutlet weak var register93: UITextField!
    @IBOutlet weak var register94: UITextField!
    @IBOutlet weak var register95: UITextField!
    @IBOutlet weak var register96: UITextField!
    @IBOutlet weak var register97: UITextField!
    @IBOutlet weak var register98: UITextField!
    @IBOutlet weak var register99: UITextField!
    var registerTextFieldArray: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerTextFieldArray = [register0, register1, register2, register3, register4, register5, register6, register7, register8, register9, register10,
                                  register11, register12, register13, register14, register15, register16, register17, register18, register19, register20, register21, register22,
                                  register23, register24, register25, register26, register27, register28, register29, register30, register31, register32, register33, register34,
                                  register35, register36, register37, register38, register39, register40, register41, register42, register43, register44, register45, register46,
                                  register47, register48, register49, register50, register51, register52, register53, register54, register55, register56, register57, register58,
                                  register59, register60, register61, register62, register63, register64, register65, register66, register67, register68, register69, register70,
                                  register71, register72, register73, register74, register75, register76, register77, register78, register79, register80, register81, register82,
                                  register83, register84, register85, register86, register87, register88, register89, register90, register91, register92, register93, register94,
                                  register95, register96, register97, register98, register99]
    }
    
    /*func createRegistersArray() -> [UITextField] {
        return [register0, register1, register2, register3, register4, register5, register6, register7, register8, register9, register10,
                register11, register12, register13, register14, register15, register16, register17, register18, register19, register20, register21, register22,
                register23, register24, register25, register26, register27, register28, register29, register30, register31, register32, register33, register34,
                register35, register36, register37, register38, register39, register40, register41, register42, register43, register44, register45, register46,
                register47, register48, register49, register50, register51, register52, register53, register54, register55, register56, register57, register58,
                register59, register60, register61, register62, register63, register64, register65, register66, register67, register68, register69, register70,
                register71, register72, register73, register74, register75, register76, register77, register78, register79, register80, register81, register82,
                register83, register84, register85, register86, register87, register88, register89, register90, register91, register92, register93, register94,
                register95, register96, register97, register98, register99]
    }*/
    

}
