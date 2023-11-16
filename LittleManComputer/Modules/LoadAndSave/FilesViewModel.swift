//
//  FilesViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 5/9/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation

class FilesViewModel {
    private var appState: AppState?
    private let compiler = Compiler()
    
    init(appState: AppState?) {
        self.appState = appState
    }
    
    func loadProgramWithURLs(_ URLs: [URL]) {
        do {
            let fileURL = URLs[0]
            let code = try String(contentsOf: fileURL, encoding: .utf8)
            appState?.sourceCode = code
            appState?.programState = try compiler.compile(code)
            appState?.updateVirtualMachine()
        } catch {
            appState?.showAlert("loadFileError")
        }
    }
    
    func saveProgramAs(_ name: String) {
        do {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            let fileURL = documentsDirectory.appendingPathComponent("\(name).txt")
            try appState?.sourceCode.write(to: fileURL, atomically: false, encoding: .utf8)
            appState?.showAlert("saveSuccess")
        } catch {
            appState?.showAlert("saveFileError")
        }
    }
}
