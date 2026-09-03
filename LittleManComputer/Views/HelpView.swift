import SwiftUI
import CoreLittleManComputer

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(EditorState.self) private var state

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HelpSection(title: "The Little Man", symbol: "figure.stand", tint: .blue) {
                        Text("The Little Man Computer is a model of a simple computer. A little man works in a room with 100 mailboxes numbered 00 to 99, a calculator called the accumulator, a counter that tells him which mailbox to read next, and two baskets for input and output. Your program is a set of three-digit instructions placed in the mailboxes.")
                    }

                    HelpSection(title: "Instructions", symbol: "list.number", tint: .green) {
                        VStack(spacing: 8) {
                            ForEach(Opcode.allCases, id: \.self) { opcode in
                                InstructionRow(code: codePattern(for: opcode), mnemonic: opcode.mnemonic, summary: opcode.summary)
                            }
                            InstructionRow(code: "", mnemonic: "DAT", summary: "Reserve a mailbox, optionally with a starting value.")
                        }
                    }

                    HelpSection(title: "Writing Programs", symbol: "text.alignleft", tint: .purple) {
                        VStack(alignment: .leading, spacing: 8) {
                            HelpBullet("One instruction per line: an optional label, the mnemonic, then a mailbox number or label.")
                            HelpBullet("Labels name a mailbox. Use one on a line, then refer to it anywhere: LOOP BRA LOOP.")
                            HelpBullet("Comments start with // and run to the end of the line.")
                            HelpBullet("DAT 5 puts 5 in a mailbox. DAT on its own puts 0.")
                            HelpBullet("Mnemonics and labels can be written in any case. STO and COB also work.")
                        }
                    }

                    HelpSection(title: "How the Machine Behaves", symbol: "cpu", tint: .orange) {
                        VStack(alignment: .leading, spacing: 8) {
                            HelpBullet("Mailboxes hold 000 to 999. The accumulator holds -999 to 999.")
                            HelpBullet("BRZ branches when the accumulator is zero. BRP branches when it is zero or positive.")
                            HelpBullet("Storing a negative accumulator keeps its low three digits, so -1 is stored as 999.")
                            HelpBullet("If ADD or SUB leaves the accumulator's range the program stops with an error, unless you choose wrap-around in Settings.")
                            HelpBullet("INP pauses the program until you place a card in the in-basket.")
                        }
                    }

                    HelpSection(title: "Using the App", symbol: "hand.tap", tint: .pink) {
                        VStack(alignment: .leading, spacing: 8) {
                            HelpBullet("Write a program, then tap Assemble to load it into the mailboxes.")
                            HelpBullet("Step runs one instruction. Run keeps going at the speed you choose.")
                            HelpBullet("Tap a mailbox to change its value. Press and hold to set a breakpoint.")
                            HelpBullet("Save programs from the Programs screen, or load a sample to see how things work.")
                        }
                    }

                    HelpSection(title: "Samples", symbol: "doc.text", tint: .teal) {
                        VStack(spacing: 8) {
                            ForEach(SamplePrograms.all) { sample in
                                Button {
                                    state.load(sample.source)
                                    dismiss()
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(sample.title)
                                                .foregroundStyle(.primary)
                                            Text(sample.summary)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "arrow.down.circle")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Help")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func codePattern(for opcode: Opcode) -> String {
        opcode.takesAddress ? "\(opcode.baseWord.hundredsDigit)xx" : opcode.baseWord.description
    }
}

struct HelpSection<Content: View>: View {
    let title: String
    let symbol: String
    let tint: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(tint)
            content
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .panel()
    }
}

struct InstructionRow: View {
    let code: String
    let mnemonic: String
    let summary: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(code)
                .frame(width: 36, alignment: .leading)
                .foregroundStyle(.secondary)
            Text(mnemonic)
                .frame(width: 40, alignment: .leading)
                .fontWeight(.semibold)
            Text(summary)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .font(.system(.body, design: .monospaced))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HelpBullet: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("•")
            Text(text)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    HelpView()
        .environment(appState)
        .environment(appState.editorState)
}
