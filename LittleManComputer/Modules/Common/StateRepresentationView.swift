//
//  StateRepresentationView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/3/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct StateRepresentationView: View {
    private var title = ""
    @Binding var value: Int
    
    init(title: String, value: Binding<Int>) {
        self.title = title
        self._value = value
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .lineLimit(1)
            Text("\(value)")
                .font(.system(size: 12))
            Spacer()
        }
    }
}

struct StateRepresentationView_Previews: PreviewProvider {
    static var previews: some View {
        StateRepresentationView(title: "Test", value: .constant(23))
    }
}
