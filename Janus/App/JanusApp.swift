import AppKit
import SwiftUI

@main
struct JanusApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var accessibilityManager = AccessibilityManager()
    @StateObject private var windowTracker = WindowTracker()
    @StateObject private var windowStateStore = WindowStateStore()

    var body: some Scene {
        WindowGroup("Janus", id: "main") {
            ContentView()
                .environmentObject(accessibilityManager)
                .environmentObject(windowTracker)
                .environmentObject(windowStateStore)
                .frame(minWidth: 900, minHeight: 640)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Check Accessibility Permission") {
                    accessibilityManager.refresh()
                }
                .keyboardShortcut("r", modifiers: [.command])

                Button("Refresh Windows") {
                    accessibilityManager.refresh()
                    windowTracker.refreshWindows()
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
            }
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}
