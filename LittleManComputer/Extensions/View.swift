//
//  View.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/12/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

extension View {
  func keyboardObserving() -> some View {
    self.modifier(KeyboardObserving())
  }
}
