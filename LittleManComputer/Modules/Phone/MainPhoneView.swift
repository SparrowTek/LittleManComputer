//
//  MainPhoneView.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 3/29/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import SwiftUI

struct MainPhoneView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        MainCompactPhoneView()
//        if sizeClass == .compact {
//            return MainCompactPhoneView()
//        } else {
//            return MainRegularPhoneView()
//        }
    }
}

struct MainPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        MainPhoneView()
    }
}
