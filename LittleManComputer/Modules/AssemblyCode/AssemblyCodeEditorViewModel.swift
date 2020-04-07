//
//  AssemblyCodeEditorViewModel.swift
//  LittleManComputer
//
//  Created by Thomas J. Rademaker on 4/6/20.
//  Copyright © 2020 SparrowTek LLC. All rights reserved.
//

import Foundation
import Combine

class AssemblyCodeEditorViewModel { //: ObservableObject {
//    @Published var programState: ProgramState
    private let compiler = Compiler()
    
//    init(programState: ProgramState) {
//        self.programState = programState
//    }
    
    func compileCode(_ code: String) {
//        do {
//            programState = try compiler.compile(code)
//        } catch (let error as CompileError) {
//            switch error {
//            case .intExpected:
//                return
//            case .invalidAssemblyCode:
//                return
//            }
//        } catch {
//            #warning("catch all")
//        }
    }
}
