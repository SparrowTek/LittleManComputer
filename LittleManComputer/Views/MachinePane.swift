import SwiftUI
import CoreLittleManComputer

struct MachinePane: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                RegistersView()
                MemoryGridView()
                BasketsView()
                ListingView()
            }
            .padding()
        }
    }
}

/// Program counter, accumulator, cycle count and status.
struct RegistersView: View {
    @Environment(EditorState.self) private var state

    var body: some View {
        let machine = state.machine.machine

        VStack(spacing: 12) {
            HStack(spacing: 12) {
                RegisterCard(title: "Program Counter", value: machine.programCounter.description, tint: .blue)
                RegisterCard(title: "Accumulator", value: machine.accumulator.description, tint: .purple)
            }
            HStack(spacing: 12) {
                RegisterCard(title: "Cycles", value: String(machine.cycleCount), tint: .green)
                RegisterCard(title: "Status", value: statusText, tint: statusTint)
            }
            if let message = state.statusMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .panel()
    }

    private var statusText: String {
        if state.machine.isRunning {
            return "Running"
        }
        switch state.machine.machine.status {
        case .ready: return "Ready"
        case .awaitingInput: return "Needs input"
        case .halted: return "Halted"
        case .faulted: return "Fault"
        }
    }

    private var statusTint: Color {
        if state.machine.isRunning {
            return .green
        }
        switch state.machine.machine.status {
        case .ready: return .secondary
        case .awaitingInput: return .orange
        case .halted: return .blue
        case .faulted: return .red
        }
    }
}

struct RegisterCard: View {
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.system(.title2, design: .monospaced, weight: .bold))
                .foregroundStyle(tint)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

/// The in-basket queue and the out-basket history.
struct BasketsView: View {
    @Environment(EditorState.self) private var state

    var body: some View {
        let machine = state.machine.machine

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("In-Basket")
                    .font(.headline)
                Spacer()
                Button("Add Card", systemImage: "plus.circle") {
                    state.requestInput()
                }
                .font(.subheadline)
            }
            ValueChips(values: machine.inbox.map(\.description), placeholder: "No cards waiting", tint: .orange)

            Text("Out-Basket")
                .font(.headline)
            ValueChips(values: machine.outbox.map(\.description), placeholder: "Nothing output yet", tint: .blue)
        }
        .panel()
    }
}

struct ValueChips: View {
    let values: [String]
    let placeholder: String
    let tint: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if values.isEmpty {
                    Text(placeholder)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                        Text(value)
                            .font(.system(.body, design: .monospaced, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(tint, in: Capsule())
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }
}

/// The assembled program, one mailbox per row, with the current instruction highlighted.
struct ListingView: View {
    @Environment(EditorState.self) private var state

    var body: some View {
        if let program = state.program, !program.lines.isEmpty {
            let machine = state.machine.machine
            let lastAddress = state.machine.lastCycle?.address

            VStack(alignment: .leading, spacing: 8) {
                Text("Program")
                    .font(.headline)
                ForEach(program.lines, id: \.address) { line in
                    ListingRow(
                        line: line,
                        word: machine.memory[line.address],
                        isNext: machine.programCounter == line.address && !machine.status.hasStopped,
                        wasLast: lastAddress == line.address
                    )
                }
            }
            .panel()
        }
    }
}

struct ListingRow: View {
    let line: Program.Line
    let word: Word
    let isNext: Bool
    let wasLast: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(line.address.description)
                .foregroundStyle(.secondary)
            Text(word.description)
                .foregroundStyle(isNext ? .primary : .secondary)
            Text(line.label ?? "")
                .frame(width: 72, alignment: .leading)
                .foregroundStyle(Color.accentColor)
            Text(statement)
            Spacer()
            if isNext {
                Image(systemName: "arrow.right")
                    .foregroundStyle(Color.accentColor)
            }
        }
        .font(.system(.footnote, design: .monospaced))
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(background, in: RoundedRectangle(cornerRadius: 6))
    }

    private var statement: String {
        if line.kind == .instruction, let instruction = Instruction(word: word), instruction.word == word {
            instruction.description
        } else {
            "DAT \(word.rawValue)"
        }
    }

    private var background: Color {
        if isNext {
            Color.accentColor.opacity(0.18)
        } else if wasLast {
            Color.blue.opacity(0.1)
        } else {
            .clear
        }
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    MachinePane()
        .environment(appState)
        .environment(appState.editorState)
}
