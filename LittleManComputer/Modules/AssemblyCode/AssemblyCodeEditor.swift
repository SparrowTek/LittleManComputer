//
//  AssemblyCodeEditor.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct AssemblyCodeEditor: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("assemblyCodeEditorTitle")
                    .padding([.leading], 32)
                    .padding(.top, 16)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            Rectangle()
                .fill(Color(Colors.textEditorBackground))
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 20)
            }
    }
}

struct AssemblyCodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        AssemblyCodeEditor()
    }
}
