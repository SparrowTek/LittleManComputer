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
    @State var keyboardHeight: CGFloat = 0
    var cancellables: Set<AnyCancellable> = []
    
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
    
    var body: some View {
        VStack {
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
    
    private func doneAction() {
        UIApplication.shared.endEditing()
    }
}

struct InputAccessory_Previews: PreviewProvider {
    static var previews: some View {
        InputAccessory().environmentObject(AppState())
    }
}
