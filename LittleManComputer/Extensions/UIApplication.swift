//
//  UIApplication.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/26/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import UIKit

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
