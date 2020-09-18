//
//  HelpViewController.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/9/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import UIKit
import SwiftUI
import SafariServices

class WikiViewController: SFSafariViewController {}

struct WikiView: UIViewControllerRepresentable {
    typealias UIViewControllerType = WikiViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<WikiView>) -> WikiViewController {
        guard let url = URL(string: "https://wikipedia.org/wiki/Little_man_computer") else { fatalError("The wiki URL is incorrect") }
        return WikiViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: WikiViewController, context: Context) {}
}
