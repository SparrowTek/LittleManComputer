import SwiftUI

@main
struct LittleManComputerApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppPresenter()
                .environment(appState)
                .setupModel()
        }
    }
}
