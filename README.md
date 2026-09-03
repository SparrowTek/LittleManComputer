# Little Man Computer for iOS and iPadOS

Write Little Man Computer assembly, assemble it into the 100 mailboxes, then
step or run the program while watching the accumulator, the program counter,
the baskets and every mailbox change. Built on
[CoreLittleManComputer](../CoreLittleManComputer), the same engine behind the
`lmc` command-line tool.

Learn about the Little Man Computer on
[Wikipedia](https://en.wikipedia.org/wiki/Little_Man_Computer).

## Using the app

- Write a program in the editor, then tap **Assemble**. Problems are listed
  under the editor with their line numbers.
- **Step** runs one instruction; **Run** keeps going at the speed chosen in
  the speed menu or Settings. When the program needs input the app asks for
  a card.
- Tap a mailbox to change its value. Press and hold one to set a breakpoint.
- **Programs** saves what is in the editor and loads saved programs or the
  built-in samples. **Help** explains the instruction set and how the
  machine behaves.

Sample to try:

```
     INP
     OUT
LOOP BRZ QUIT
     SUB ONE
     OUT
     BRA LOOP
QUIT HLT
ONE  DAT 1
```

Enter 3 and the out-basket fills with 3, 2, 1, 0.

## Architecture

SwiftUI throughout, Swift 6 with main-actor default isolation, and SwiftData
for saved programs.

- `System` – the `App` and `AppState`, which owns routing, sheets and alerts.
- `States` – `EditorState`, a `@MainActor @Observable` object that owns the
  editor text, the assembled program and an `ObservableMachine` from the
  engine. Engine work runs through `TaskTrigger`s attached in the presenter,
  never in free-floating tasks.
- `Presenters` – `AppPresenter` and `EditorPresenter`, which handle
  navigation, sheets, alerts and the task modifiers.
- `Views` – the editor, memory grid, registers, baskets, listing, and the
  help, library, settings and input sheets.
- `Model` – the SwiftData schema, `SavedProgram`, and the preview trait that
  seeds sample data.

The Xcode project uses synchronized folders, so adding a file on disk adds
it to the target.

## Building

Requires Xcode 26 and macOS 26.

- Clone the repo
- `cp User.xcconfig.template User.xcconfig`
- Set your team and bundle prefix in `User.xcconfig`
- Build and run with Xcode

Unit tests use Swift Testing and cover `EditorState` and the SwiftData
model.

## Contributing

It is always a good idea to **discuss** before taking on a significant task.
That said, I have a strong bias towards enthusiasm. If you are excited about
doing something, I'll do my best to get out of your way.

By participating in this project you agree to abide by the
[Contributor Code of Conduct](CODE_OF_CONDUCT.md).

## Project State

The code in this repo is live in the Apple iOS App Store.
