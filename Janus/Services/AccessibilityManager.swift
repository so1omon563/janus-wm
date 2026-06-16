import ApplicationServices
import AppKit
import Foundation

@MainActor
final class AccessibilityManager: ObservableObject {
    @Published private(set) var isTrusted: Bool
    @Published private(set) var lastCheckedAt: Date

    init() {
        self.isTrusted = AXIsProcessTrusted()
        self.lastCheckedAt = Date()
    }

    func refresh() {
        isTrusted = AXIsProcessTrusted()
        lastCheckedAt = Date()
    }

    func requestAccess() {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary

        isTrusted = AXIsProcessTrustedWithOptions(options)
        lastCheckedAt = Date()
        openAccessibilityPrivacySettings()
    }

    var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "Missing bundle identifier"
    }

    var bundlePath: String {
        Bundle.main.bundlePath
    }

    var executablePath: String {
        Bundle.main.executablePath ?? "Missing executable path"
    }

    private func openAccessibilityPrivacySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            return
        }

        NSWorkspace.shared.open(url)
    }
}
