import Foundation
import Testing
import CoreLittleManComputer
@testable import LMC

@MainActor
@Suite("EditorState")
struct EditorStateTests {
    private func makeStates() throws -> (app: AppState, editor: EditorState, defaults: UserDefaults) {
        let defaults = try #require(UserDefaults(suiteName: "EditorStateTests.\(UUID().uuidString)"))
        let app = AppState()
        let editor = EditorState(parentState: app, defaults: defaults)
        return (app, editor, defaults)
    }

    @Test func startsWithTheCountdownSample() throws {
        let (_, editor, _) = try makeStates()
        #expect(editor.source == SamplePrograms.countdown.source)
        #expect(!editor.isAssembled)
        #expect(editor.needsAssembly)
        #expect(!editor.canStep)
        #expect(editor.speedSetting == .normal)
        #expect(editor.overflowBehavior == .fault)
    }

    @Test func assemblingValidSourceLoadsTheMachine() async throws {
        let (_, editor, _) = try makeStates()
        editor.source = SamplePrograms.echo.source
        await editor.perform(.assemble)

        let program = try #require(editor.program)
        #expect(program.length == 3)
        #expect(editor.diagnostics.isEmpty)
        #expect(!editor.needsAssembly)
        #expect(editor.pane == .machine)
        #expect(editor.canStep)
        #expect(await editor.machine.engine.machine.memory == program.memory)
    }

    @Test func assemblingInvalidSourceReportsProblems() async throws {
        let (_, editor, _) = try makeStates()
        editor.source = "ADD\nBRA NOWHERE"
        await editor.perform(.assemble)

        #expect(editor.program == nil)
        #expect(editor.diagnostics.map(\.line) == [1, 2])
        #expect(editor.pane == .code)
    }

    @Test func editingAfterAssemblyNeedsAnotherAssemble() async throws {
        let (_, editor, _) = try makeStates()
        editor.source = SamplePrograms.echo.source
        await editor.perform(.assemble)
        #expect(!editor.needsAssembly)
        editor.source += "\n"
        #expect(editor.needsAssembly)
    }

    @Test func steppingIntoInputPresentsTheInputSheet() async throws {
        let (app, editor, _) = try makeStates()
        editor.source = SamplePrograms.echo.source
        await editor.perform(.assemble)
        await editor.perform(.step)
        #expect(app.sheet == .input)

        await editor.perform(.provideInput(5))
        #expect(await editor.machine.engine.machine.inbox == [5])
    }

    @Test func runningToHaltCollectsOutputs() async throws {
        let (_, editor, _) = try makeStates()
        editor.source = SamplePrograms.countdown.source
        editor.speedSetting = .maximum
        await editor.perform(.assemble)
        await editor.perform(.provideInput(2))
        await editor.runProgram()

        let machine = await editor.machine.engine.machine
        #expect(machine.status == .halted)
        #expect(machine.outbox == [2, 1, 0])
    }

    @Test func faultsBecomeAlerts() async throws {
        let (app, editor, _) = try makeStates()
        editor.source = "400"
        await editor.perform(.assemble)
        await editor.perform(.step)

        guard case .fault(let fault) = app.alert else {
            Issue.record("Expected a fault alert, got \(String(describing: app.alert))")
            return
        }
        #expect(fault == .invalidInstruction(word: 400, address: 0))
    }

    @Test func breakpointsStopRunsAndCanBeToggled() async throws {
        let (_, editor, _) = try makeStates()
        editor.source = "INP\nOUT\nHLT"
        editor.speedSetting = .maximum
        await editor.perform(.assemble)
        await editor.perform(.provideInput(1))
        await editor.perform(.toggleBreakpoint(1))
        #expect(editor.breakpoints == [1])

        await editor.runProgram()
        #expect(await editor.machine.engine.machine.programCounter == 1)
        #expect(editor.statusMessage == "Stopped at breakpoint 01")

        await editor.perform(.toggleBreakpoint(1))
        #expect(editor.breakpoints.isEmpty)
    }

    @Test func resetReturnsToTheStart() async throws {
        let (_, editor, _) = try makeStates()
        editor.source = "INP\nOUT\nHLT"
        await editor.perform(.assemble)
        await editor.perform(.provideInput(1))
        await editor.perform(.step)
        await editor.perform(.reset)

        let machine = await editor.machine.engine.machine
        #expect(machine.cycleCount == 0)
        #expect(machine.inbox.isEmpty)
    }

    @Test func writesReachTheMailboxes() async throws {
        let (_, editor, _) = try makeStates()
        await editor.perform(.write(902, at: 7))
        #expect(await editor.machine.engine.machine.memory[7] == 902)
    }

    @Test func persistsTheDraftAndSettings() async throws {
        let (app, editor, defaults) = try makeStates()
        editor.source = "INP"
        editor.speedSetting = .fastest
        await editor.perform(.setOverflowBehavior(.wrap))

        let restored = EditorState(parentState: app, defaults: defaults)
        #expect(restored.source == "INP")
        #expect(restored.speedSetting == .fastest)
        #expect(restored.overflowBehavior == .wrap)
        #expect(await restored.machine.engine.machine.overflowBehavior == .wrap)
    }

    @Test func speedSettingsMapToExecutionSpeeds() {
        #expect(EditorState.SpeedSetting.maximum.executionSpeed == .maximum)
        #expect(EditorState.SpeedSetting.normal.executionSpeed == .hertz(2))
        #expect(EditorState.SpeedSetting.allCases.last == .maximum)
    }
}
