//
//  InputAccessory.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/25/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI
import Combine

struct InputAccessory: View {
    @State private var keyboardHeight: CGFloat = 0
    @State private var isVisible = false
    private var cancellables: Set<AnyCancellable> = []
    private var action: (() -> Void)?
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
          .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
          .compactMap({ notification in
            guard let keyboardFrameValue: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
            let keyboardFrame = keyboardFrameValue.cgRectValue
            // If the rectangle is at the bottom of the screen, set the height to 0.
            if keyboardFrame.origin.y == UIScreen.main.bounds.height {
              return 0
            } else {
              // Adjust for safe area
              return keyboardFrame.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
            }
          })
          .assign(to: \.keyboardHeight, on: self)
          .store(in: &cancellables)
    }
    
    init(withAction action: @escaping (() -> Void)) {
        self.action = action
    }
    
    var body: some View {
        VStack {
            if isVisible {
                HStack {
                    Spacer()
                    LMCButton(title: "inputAccessoryButton", height: 30, width: 75, action: doneAction)
                        .padding(.trailing, 16)
                }
                .frame(height: 38)
                .background(Color(Colors.inputAccessoryBackground))
                Spacer()
                    .frame(height: keyboardHeight)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: toggleIsVisibleOn )
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: toggleIsVisibleOff )
    }
    
    private func toggleIsVisibleOn(_ notification: Notification) {
        isVisible = true
    }
    
    private func toggleIsVisibleOff(_ notification: Notification) {
        isVisible = false
    }
    
    private func doneAction() {
        UIApplication.shared.endEditing()
        action?()
    }
}

struct InputAccessory_Previews: PreviewProvider {
    static var previews: some View {
        InputAccessory().environmentObject(AppState())
    }
}
