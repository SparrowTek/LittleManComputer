//
//  FilesViewController.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/9/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import UIKit
import SwiftUI

class FilesViewController: UIDocumentPickerViewController {
    private var appState: AppState?
    private lazy var viewModel = FilesViewModel(appState: appState)
    
    convenience init(appState: AppState) {
        self.init(forOpeningContentTypes: [.text], asCopy: true)
        delegate = self
        self.appState = appState
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        directoryURL = documentsDirectory
    }
}

extension FilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        viewModel.loadProgramWithURLs(urls)
    }
}

struct FolderView: UIViewControllerRepresentable {
    typealias UIViewControllerType = FilesViewController
    @EnvironmentObject var appState: AppState
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FolderView>) -> FilesViewController {
        return FilesViewController(appState: appState)
    }
    
    func updateUIViewController(_ uiViewController: FilesViewController, context: Context) {}
}
