//
//  HelpView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 9/17/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showWiki = false
    private var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    private var isIpadAndRegularWidth: Bool {
        appState.isIpad && horizontalSizeClass == .regular }
    
    var body: some View {
        VStack {
            if isIpadAndRegularWidth {
                SheetTopClose()
            } else {
                SheetTopBar()
            }
            Spacer()
            LMCButton(title: "instructions", maxHeight: 50, maxWidth: .infinity, action: { showWiki.toggle() })
                .padding()
            Spacer()
            Text("settingsTitle")
                .font(.system(size: 20, weight: .bold))
            HStack {
                VStack {
                    HStack {
                        Text("version")
                        Text(appVersion ?? "")
                    }
                    Button(action: {
                        guard let url = URL(string: "https://sparrowtek.com") else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Text("SparrowTek")
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .padding(.leading)
                Spacer()
                Image("sparrowtek")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
            }
        }
        .background(Color(Colors.launchScreen))
        .sheet(isPresented: $showWiki) {
                WikiView()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
