import Foundation
import Observation
import CoreLittleManComputer

@Observable
@MainActor
class EditorState {
    nonisolated enum Pane: Int, CaseIterable, Identifiable {
        case code
        case machine

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .code: "Code"
            case .machine: "Machine"
            }
        }
    }

    nonisolated enum SpeedSetting: Int, CaseIterable, Identifiable {
        case slow = 1
        case normal = 2
        case fast = 4
        case faster = 8
        case fastest = 16
        case maximum = 0

        var id: Int { rawValue }

        var title: String {
            self == .maximum ? "Maximum" : "\(rawValue) per second"
        }

        var executionSpeed: ExecutionSpeed {
            self == .maximum ? .maximum : .hertz(Double(rawValue))
        }
    }

    /// Short pieces of engine work, run one at a time through ``commandTrigger``.
    nonisolated enum Command: Equatable, Sendable {
        case assemble
        case step
        case pause
        case reset
        case provideInput(Word)
        case write(Word, at: MailboxAddress)
        case toggleBreakpoint(MailboxAddress)
        case setOverflowBehavior(OverflowBehavior)
    }

    unowned let parentState: AppState

    /// The engine mirror views read from. Kept current by ``EditorPresenter``.
    let machine: ObservableMachine

    var source: String {
        didSet { defaults.set(source, forKey: Key.source) }
    }

    var pane: Pane = .code
    var editingAddress: MailboxAddress?
    var runTrigger = PlainTaskTrigger()
    var commandTrigger = TaskTrigger<Command>()

    var speedSetting: SpeedSetting {
        didSet {
            defaults.set(speedSetting.rawValue, forKey: Key.speed)
            if machine.isRunning {
                restartRun = true
                pause()
            }
        }
    }

    private(set) var program: Program?
    private(set) var diagnostics: [AssemblyDiagnostic] = []
    private(set) var breakpoints: Set<MailboxAddress> = []
    private(set) var statusMessage: String?
    private(set) var overflowBehavior: OverflowBehavior

    private let defaults: UserDefaults
    private var assembledSource: String?
    private var resumeAfterInput = false
    private var restartRun = false

    init(parentState: AppState, defaults: UserDefaults = .standard) {
        self.parentState = parentState
        self.defaults = defaults

        let overflow = defaults.string(forKey: Key.overflow).flatMap(OverflowBehavior.init(rawValue:)) ?? .fault
        overflowBehavior = overflow
        source = defaults.string(forKey: Key.source) ?? SamplePrograms.countdown.source
        if defaults.object(forKey: Key.speed) != nil, let saved = SpeedSetting(rawValue: defaults.integer(forKey: Key.speed)) {
            speedSetting = saved
        } else {
            speedSetting = .normal
        }
        machine = ObservableMachine(program: .empty, overflowBehavior: overflow)
    }

    // MARK: - Derived state

    var isAssembled: Bool {
        program != nil
    }

    var needsAssembly: Bool {
        assembledSource != source
    }

    var canStep: Bool {
        isAssembled && !machine.isRunning && !machine.machine.status.hasStopped
    }

    var canRun: Bool {
        isAssembled && !machine.machine.status.hasStopped
    }

    var isAwaitingInput: Bool {
        machine.machine.status == .awaitingInput
    }

    // MARK: - Actions for views

    func assemble() {
        commandTrigger.trigger(value: .assemble)
    }

    func step() {
        commandTrigger.trigger(value: .step)
    }

    func run() {
        runTrigger.trigger()
    }

    func pause() {
        commandTrigger.trigger(value: .pause)
    }

    func reset() {
        commandTrigger.trigger(value: .reset)
    }

    func provideInput(_ word: Word) {
        commandTrigger.trigger(value: .provideInput(word))
    }

    func write(_ word: Word, at address: MailboxAddress) {
        commandTrigger.trigger(value: .write(word, at: address))
    }

    func toggleBreakpoint(at address: MailboxAddress) {
        commandTrigger.trigger(value: .toggleBreakpoint(address))
    }

    func setOverflowBehavior(_ behavior: OverflowBehavior) {
        commandTrigger.trigger(value: .setOverflowBehavior(behavior))
    }

    func requestInput() {
        parentState.sheet = .input
    }

    /// Replaces the editor text and assembles it.
    func load(_ text: String) {
        source = text
        assemble()
    }

    // MARK: - Work performed by task modifiers

    func perform(_ command: Command) async {
        switch command {
        case .assemble:
            await performAssemble()
        case .step:
            handle(await machine.step())
        case .pause:
            await machine.pause()
        case .reset:
            resumeAfterInput = false
            statusMessage = nil
            await machine.reset()
        case .provideInput(let word):
            await machine.provideInput(word)
            if resumeAfterInput {
                resumeAfterInput = false
                runTrigger.trigger()
            }
        case .write(let word, let address):
            await machine.write(word, at: address)
        case .toggleBreakpoint(let address):
            await machine.engine.toggleBreakpoint(address)
            breakpoints = await machine.engine.breakpoints
        case .setOverflowBehavior(let behavior):
            overflowBehavior = behavior
            defaults.set(behavior.rawValue, forKey: Key.overflow)
            await machine.engine.setOverflowBehavior(behavior)
        }
    }

    /// Runs until the program stops, restarting when the speed changes mid-run.
    func runProgram() async {
        repeat {
            restartRun = false
            statusMessage = nil
            let outcome = await machine.run(speed: speedSetting.executionSpeed)
            if !restartRun {
                handle(outcome)
            }
        } while restartRun
    }

    private func performAssemble() async {
        do {
            let program = try Assembler().assemble(source)
            self.program = program
            assembledSource = source
            diagnostics = []
            resumeAfterInput = false
            statusMessage = nil
            await machine.load(program)
            pane = .machine
        } catch {
            diagnostics = error.diagnostics
            pane = .code
        }
    }

    private func handle(_ outcome: StepOutcome) {
        switch outcome {
        case .executed, .notRunning:
            break
        case .awaitingInput:
            resumeAfterInput = false
            parentState.sheet = .input
        case .faulted(let fault):
            parentState.alert = .fault(fault)
        }
    }

    private func handle(_ outcome: RunOutcome) {
        switch outcome {
        case .halted, .paused, .cycleLimitReached, .alreadyRunning:
            break
        case .awaitingInput:
            resumeAfterInput = true
            parentState.sheet = .input
        case .breakpoint(let address):
            statusMessage = "Stopped at breakpoint \(address)"
        case .faulted(let fault):
            parentState.alert = .fault(fault)
        }
    }

    private enum Key {
        static let source = "editor.source"
        static let speed = "editor.speed"
        static let overflow = "editor.overflow"
    }
}
