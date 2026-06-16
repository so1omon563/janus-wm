import Foundation

enum WindowMode: String, Codable, CaseIterable, Identifiable {
    case floating
    case managed

    var id: String { rawValue }

    var label: String {
        switch self {
        case .floating:
            return "Floating"
        case .managed:
            return "Managed"
        }
    }
}

@MainActor
final class WindowStateStore: ObservableObject {
    @Published private var modesByWindowKey: [String: WindowMode]

    private let defaults: UserDefaults
    private let defaultsKey = "windowModesByKey"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.modesByWindowKey = Self.loadModes(from: defaults, key: defaultsKey)
    }

    func mode(for window: WindowInfo) -> WindowMode {
        modesByWindowKey[window.stateKey] ?? .floating
    }

    func setMode(_ mode: WindowMode, for window: WindowInfo) {
        modesByWindowKey[window.stateKey] = mode
        save()
    }

    func toggleMode(for window: WindowInfo) {
        setMode(mode(for: window) == .managed ? .floating : .managed, for: window)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(modesByWindowKey) else {
            return
        }

        defaults.set(data, forKey: defaultsKey)
    }

    private static func loadModes(from defaults: UserDefaults, key: String) -> [String: WindowMode] {
        guard let data = defaults.data(forKey: key),
              let modes = try? JSONDecoder().decode([String: WindowMode].self, from: data) else {
            return [:]
        }

        return modes
    }
}
