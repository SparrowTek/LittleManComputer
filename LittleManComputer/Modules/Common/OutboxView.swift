//
//  OutboxView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/3/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct OutboxView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Text("outboxTitle")
            
            List {
                ForEach(appState.programState.outbox, id: \.self) {
                    Text($0.toStringWith3IntegerDigits())
                        .frame(height: 10)
                        .foregroundColor(Color(Colors.outboxText))
                        .listRowBackground(Color(Colors.outboxBackground))
                }
            }
            .environment(\.defaultMinListRowHeight, 10)
            .frame(width: 75, height: 150)
            .background(Color(Colors.outboxBackground))
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
        }
        .frame(width: 150, height: 150)
    }
}

struct OutboxView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        appState.programState.outbox = [3, 8]
        return OutboxView().environmentObject(appState)
    }
}
