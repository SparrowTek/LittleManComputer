//
//  KeyboardObserving.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/12/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct KeyboardObserving: ViewModifier {

  @State var keyboardHeight: CGFloat = 0
  @State var keyboardAnimationDuration: Double = 0

  func body(content: Content) -> some View {
    content
      .padding([.bottom], keyboardHeight)
      .edgesIgnoringSafeArea((keyboardHeight > 0) ? [.bottom] : [])
      .animation(.easeOut(duration: keyboardAnimationDuration))
      .onReceive(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
          .receive(on: RunLoop.main),
        perform: updateKeyboardHeight
      )
  }

  func updateKeyboardHeight(_ notification: Notification) {
    guard let info = notification.userInfo else { return }
    // Get the duration of the keyboard animation
    keyboardAnimationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25

    guard let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    // If the top of the frame is at the bottom of the screen, set the height to 0.
    if keyboardFrame.origin.y == UIScreen.main.bounds.height {
      keyboardHeight = 0
    } else {
      // IMPORTANT: This height will _include_ the SafeAreaInset height.
      keyboardHeight = keyboardFrame.height
    }
  }
}

