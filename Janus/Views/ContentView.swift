import AppKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var accessibilityManager: AccessibilityManager
    @EnvironmentObject private var windowTracker: WindowTracker
    @EnvironmentObject private var windowStateStore: WindowStateStore
    @State private var selectedWindowID: WindowInfo.ID?
    @State private var restoreFrames: [WindowInfo.ID: CGRect] = [:]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header

                VStack(alignment: .leading, spacing: 16) {
                    permissionStatus
                    permissionDiagnostics
                    Divider()
                    windowList
                }
                .padding(20)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(28)
        }
        .onAppear {
            refreshPermissionAndWindows()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Janus")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("Native macOS window control starts with Accessibility permission.")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }

    private var permissionStatus: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: accessibilityManager.isTrusted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(accessibilityManager.isTrusted ? .green : .orange)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(accessibilityManager.isTrusted ? "Accessibility access is enabled" : "Accessibility access is needed")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(accessibilityManager.isTrusted
                     ? "Janus can ask macOS about windows and move toward window discovery."
                     : "macOS requires this permission before Janus can discover or move windows.")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(accessibilityManager.isTrusted ? "Refresh" : "Open Settings") {
                if accessibilityManager.isTrusted {
                    refreshPermissionAndWindows()
                } else {
                    accessibilityManager.requestAccess()
                }
            }
            .controlSize(.large)
        }
    }

    private var permissionDiagnostics: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Identity macOS should trust")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text("Bundle ID: \(accessibilityManager.bundleIdentifier)")
                .font(.caption)
                .textSelection(.enabled)

            Text("App: \(accessibilityManager.bundlePath)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
                .textSelection(.enabled)

            Text("Checked: \(accessibilityManager.lastCheckedAt.formatted(date: .omitted, time: .standard))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var windowList: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Visible Windows", systemImage: "macwindow")
                    .font(.headline)

                Spacer()

                Button("Apply Managed Layout") {
                    applyManagedLayout()
                }
                .disabled(managedWindows.isEmpty)

                Button("Refresh") {
                    refreshPermissionAndWindows()
                }
            }

            if let message = windowTracker.lastActionMessage {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let error = windowTracker.lastRefreshError {
                Text(error)
                    .foregroundStyle(.secondary)
            } else if windowTracker.windows.isEmpty {
                Text(accessibilityManager.isTrusted
                     ? "No visible windows found yet."
                     : "Grant Accessibility access, then refresh this list.")
                    .foregroundStyle(.secondary)
            } else {
                HStack(alignment: .top, spacing: 16) {
                    List(windowTracker.windows, selection: $selectedWindowID) { window in
                        WindowRow(
                            window: window,
                            mode: windowStateStore.mode(for: window)
                        )
                            .tag(window.id)
                    }
                    .listStyle(.inset)
                    .frame(minHeight: 320)

                    selectedWindowDetail
                        .frame(width: 260)
                }
                .frame(minHeight: 340)
            }
        }
    }

    private func refreshPermissionAndWindows() {
        accessibilityManager.refresh()

        if accessibilityManager.isTrusted {
            windowTracker.refreshWindows()
            clearSelectionIfNeeded()
        }
    }

    private var selectedWindow: WindowInfo? {
        guard let selectedWindowID else {
            return nil
        }

        return windowTracker.windows.first { $0.id == selectedWindowID }
    }

    private var managedWindows: [WindowInfo] {
        windowTracker.windows.filter { windowStateStore.mode(for: $0) == .managed }
    }

    private var selectedWindowDetail: some View {
        Group {
            if let selectedWindow {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Selected", systemImage: "target")
                        .font(.headline)

                    Text(selectedWindow.displayTitle)
                        .fontWeight(.semibold)
                        .lineLimit(2)

                    Text(selectedWindow.appName)
                        .foregroundStyle(.secondary)

                    Picker("Mode", selection: modeBinding(for: selectedWindow)) {
                        ForEach(WindowMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    Divider()

                    Text("Size")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Text("\(Int(selectedWindow.frame.width)) x \(Int(selectedWindow.frame.height))")

                    Text("Position")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Text("\(Int(selectedWindow.frame.minX)), \(Int(selectedWindow.frame.minY))")

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Button("Move to Test Frame") {
                            moveSelectedWindowTest(selectedWindow)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)

                        Button("Restore Frame") {
                            restoreSelectedWindow(selectedWindow)
                        }
                        .disabled(restoreFrames[selectedWindow.id] == nil)
                        .controlSize(.large)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Label("No Selection", systemImage: "cursorarrow.click")
                        .font(.headline)

                    Text("Select a window to inspect it before Janus tries moving anything.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private func modeBinding(for window: WindowInfo) -> Binding<WindowMode> {
        Binding {
            windowStateStore.mode(for: window)
        } set: { mode in
            windowStateStore.setMode(mode, for: window)
        }
    }

    private func clearSelectionIfNeeded() {
        guard let selectedWindowID else {
            return
        }

        if !windowTracker.windows.contains(where: { $0.id == selectedWindowID }) {
            self.selectedWindowID = nil
        }

        restoreFrames = restoreFrames.filter { id, _ in
            windowTracker.windows.contains { $0.id == id }
        }
    }

    private func moveSelectedWindowTest(_ window: WindowInfo) {
        let testFrame = CGRect(x: 120, y: 120, width: 900, height: 600)

        if restoreFrames[window.id] == nil {
            restoreFrames[window.id] = window.frame
        }

        if windowTracker.moveWindow(window, to: testFrame) {
            refreshPermissionAndWindows()
        }
    }

    private func restoreSelectedWindow(_ window: WindowInfo) {
        guard let restoreFrame = restoreFrames[window.id] else {
            return
        }

        if windowTracker.moveWindow(window, to: restoreFrame) {
            restoreFrames[window.id] = nil
            refreshPermissionAndWindows()
        }
    }

    private func applyManagedLayout() {
        let windows = managedWindows
        guard !windows.isEmpty else {
            return
        }

        let frames = horizontalFrames(for: windows.count)
        var movedCount = 0

        for (window, frame) in zip(windows, frames) {
            if restoreFrames[window.id] == nil {
                restoreFrames[window.id] = window.frame
            }

            if windowTracker.moveWindow(window, to: frame) {
                movedCount += 1
            }
        }

        windowTracker.setActionMessage("Applied managed layout to \(movedCount) of \(windows.count) windows.")
        refreshPermissionAndWindows()
    }

    private func horizontalFrames(for count: Int) -> [CGRect] {
        guard count > 0 else {
            return []
        }

        let layoutBounds = mainScreenVisibleFrameForAccessibility()
        let margin: CGFloat = 12
        let gap: CGFloat = 12
        let totalGap = gap * CGFloat(max(count - 1, 0))
        let availableWidth = max(300, layoutBounds.width - (margin * 2) - totalGap)
        let availableHeight = max(360, layoutBounds.height - (margin * 2))
        let windowWidth = availableWidth / CGFloat(count)

        return (0..<count).map { index in
            CGRect(
                x: layoutBounds.minX + margin + (CGFloat(index) * (windowWidth + gap)),
                y: layoutBounds.minY + margin,
                width: windowWidth,
                height: availableHeight
            )
        }
    }

    private func mainScreenVisibleFrameForAccessibility() -> CGRect {
        let displayID = CGMainDisplayID()
        let displayBounds = CGDisplayBounds(displayID)
        guard let screen = NSScreen.screens.first(where: { screen in
            screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID == displayID
        }) else {
            return displayBounds
        }

        let visibleFrame = screen.visibleFrame
        let convertedY = displayBounds.maxY - visibleFrame.maxY

        return CGRect(
            x: visibleFrame.minX,
            y: convertedY,
            width: visibleFrame.width,
            height: visibleFrame.height
        )
    }
}

private struct WindowRow: View {
    let window: WindowInfo
    let mode: WindowMode

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: "app.connected.to.app.below.fill")
                .foregroundStyle(.secondary)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 3) {
                Text(window.displayTitle)
                    .fontWeight(.medium)
                    .lineLimit(1)

                Text("\(window.appName) - \(window.frameSummary)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(mode.label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(mode == .managed ? .blue : .secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.quaternary, in: Capsule())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .environmentObject(AccessibilityManager())
        .environmentObject(WindowTracker())
        .environmentObject(WindowStateStore())
}
