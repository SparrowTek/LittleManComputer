import SwiftUI
import CoreLittleManComputer

/// The 100 mailboxes as a ten-by-ten grid.
///
/// The program counter's mailbox is filled with the accent colour, the mailbox
/// the last instruction read is blue, and the one it wrote is orange. Tap a
/// mailbox to edit it; press and hold for breakpoints.
struct MemoryGridView: View {
    @Environment(EditorState.self) private var state

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 10)

    var body: some View {
        let machine = state.machine.machine
        let lastCycle = state.machine.lastCycle

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Mailboxes")
                    .font(.headline)
                Spacer()
                LegendSwatch(color: Color.accentColor, label: "Next")
                LegendSwatch(color: .blue.opacity(0.35), label: "Read")
                LegendSwatch(color: .orange.opacity(0.45), label: "Wrote")
            }

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(MailboxAddress.allCases, id: \.self) { address in
                    let hasBreakpoint = state.breakpoints.contains(address)
                    MailboxCell(
                        address: address,
                        word: machine.memory[address],
                        role: role(of: address, in: machine, lastCycle: lastCycle),
                        hasBreakpoint: hasBreakpoint
                    )
                    .onTapGesture {
                        state.editingAddress = address
                    }
                    .contextMenu {
                        Button(hasBreakpoint ? "Remove Breakpoint" : "Add Breakpoint", systemImage: hasBreakpoint ? "circle.slash" : "circle.fill") {
                            state.toggleBreakpoint(at: address)
                        }
                        Button("Edit Value", systemImage: "pencil") {
                            state.editingAddress = address
                        }
                    }
                }
            }
            .animation(.snappy(duration: 0.2), value: machine.programCounter)
        }
        .panel()
    }

    private func role(of address: MailboxAddress, in machine: Machine, lastCycle: Cycle?) -> MailboxCell.Role {
        if machine.programCounter == address, !machine.status.hasStopped {
            return .next
        }
        if lastCycle?.writtenAddress == address {
            return .wrote
        }
        if lastCycle?.readAddress == address {
            return .read
        }
        if state.program?.line(at: address)?.kind == .data {
            return .data
        }
        return .plain
    }
}

struct MailboxCell: View {
    enum Role {
        case next
        case read
        case wrote
        case data
        case plain
    }

    let address: MailboxAddress
    let word: Word
    let role: Role
    let hasBreakpoint: Bool

    var body: some View {
        VStack(spacing: 2) {
            Text(address.description)
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(foreground.opacity(0.7))
            Text(word.description)
                .font(.system(size: 13, weight: role == .next ? .bold : .regular, design: .monospaced))
                .foregroundStyle(foreground)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(background, in: RoundedRectangle(cornerRadius: 6))
        .overlay(alignment: .topTrailing) {
            if hasBreakpoint {
                Circle()
                    .fill(.red)
                    .frame(width: 6, height: 6)
                    .padding(3)
            }
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Mailbox \(address.description), \(word.description)")
    }

    private var background: Color {
        switch role {
        case .next: Color.accentColor
        case .read: .blue.opacity(0.35)
        case .wrote: .orange.opacity(0.45)
        case .data: Color(.tertiarySystemGroupedBackground)
        case .plain: Color(.systemBackground)
        }
    }

    private var foreground: Color {
        role == .next ? .white : .primary
    }
}

struct LegendSwatch: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    MemoryGridView()
        .environment(appState)
        .environment(appState.editorState)
        .padding()
}
