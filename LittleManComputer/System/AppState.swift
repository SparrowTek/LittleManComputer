import SwiftUI
import CoreLittleManComputer

@Observable
@MainActor
class AppState {
    enum Route: Int, Identifiable {
        case editor

        var id: Int { rawValue }
    }

    enum Sheet: Identifiable {
        case help
        case library
        case settings
        case input

        var id: Int {
            switch self {
            case .help: 1
            case .library: 2
            case .settings: 3
            case .input: 4
            }
        }
    }

    enum Alert: Identifiable {
        case fault(MachineFault)
        case error(title: String, message: String)

        var id: Int {
            switch self {
            case .fault: 1
            case .error: 2
            }
        }

        var title: String {
            switch self {
            case .fault: "Program Stopped"
            case .error(let title, _): title
            }
        }

        var message: String {
            switch self {
            case .fault(let fault): fault.description
            case .error(_, let message): message
            }
        }
    }

    var route: Route = .editor
    var sheet: Sheet?
    var alert: Alert?

    @ObservationIgnored
    lazy var editorState = EditorState(parentState: self)
}
