import ApplicationServices
import AppKit
import CoreGraphics
import Foundation

@MainActor
final class WindowTracker: ObservableObject {
    @Published private(set) var windows: [WindowInfo] = []
    @Published private(set) var lastRefreshError: String?
    @Published private(set) var lastActionMessage: String?

    func refreshWindows() {
        guard AXIsProcessTrusted() else {
            windows = []
            lastRefreshError = "Accessibility permission is required before Janus can read windows."
            return
        }

        var discoveredWindows: [WindowInfo] = []

        for application in runningWindowOwningApplications() {
            discoveredWindows.append(contentsOf: windows(for: application))
        }

        windows = discoveredWindows.sorted { first, second in
            if first.appName == second.appName {
                return first.displayTitle < second.displayTitle
            }

            return first.appName < second.appName
        }
        lastRefreshError = nil
    }

    func moveWindow(_ window: WindowInfo, to frame: CGRect) -> Bool {
        guard AXIsProcessTrusted() else {
            lastActionMessage = "Accessibility permission is required before Janus can move windows."
            return false
        }

        guard let windowElement = findWindowElement(matching: window) else {
            lastActionMessage = "Could not find that window. Refresh and select it again."
            return false
        }

        guard setCGPointAttribute("AXPosition", on: windowElement, to: frame.origin),
              setCGSizeAttribute("AXSize", on: windowElement, to: frame.size) else {
            lastActionMessage = "macOS did not allow Janus to move or resize that window."
            return false
        }

        lastActionMessage = "Moved \(window.displayTitle) to \(Int(frame.width)) x \(Int(frame.height)) at \(Int(frame.minX)), \(Int(frame.minY))."
        return true
    }

    func setActionMessage(_ message: String) {
        lastActionMessage = message
    }

    private func runningWindowOwningApplications() -> [NSRunningApplication] {
        NSWorkspace.shared.runningApplications.filter { application in
            application.activationPolicy == .regular
                && !application.isTerminated
                && application.processIdentifier != ProcessInfo.processInfo.processIdentifier
                && application.bundleIdentifier != Bundle.main.bundleIdentifier
        }
    }

    private func windows(for application: NSRunningApplication) -> [WindowInfo] {
        let appElement = AXUIElementCreateApplication(application.processIdentifier)
        guard let axWindows = copyArrayAttribute("AXWindows", from: appElement) else {
            return []
        }

        return axWindows.enumerated().compactMap { index, value in
            guard CFGetTypeID(value) == AXUIElementGetTypeID() else {
                return nil
            }

            let windowElement = value as! AXUIElement
            return windowInfo(
                for: windowElement,
                application: application,
                fallbackIndex: index
            )
        }
    }

    private func windowInfo(
        for windowElement: AXUIElement,
        application: NSRunningApplication,
        fallbackIndex: Int
    ) -> WindowInfo? {
        guard let position = copyCGPointAttribute("AXPosition", from: windowElement),
              let size = copyCGSizeAttribute("AXSize", from: windowElement),
              size.width > 0,
              size.height > 0 else {
            return nil
        }

        let title = copyStringAttribute("AXTitle", from: windowElement) ?? ""
        let appName = application.localizedName ?? "Unknown App"
        let appIdentifier = application.bundleIdentifier ?? appName
        let frame = CGRect(origin: position, size: size)
        let id = "\(application.processIdentifier)-\(fallbackIndex)-\(title)"

        return WindowInfo(
            id: id,
            appName: appName,
            appIdentifier: appIdentifier,
            processIdentifier: application.processIdentifier,
            title: title,
            frame: frame
        )
    }

    private func findWindowElement(matching window: WindowInfo) -> AXUIElement? {
        let appElement = AXUIElementCreateApplication(window.processIdentifier)
        guard let axWindows = copyArrayAttribute("AXWindows", from: appElement) else {
            return nil
        }

        for value in axWindows {
            guard CFGetTypeID(value) == AXUIElementGetTypeID() else {
                continue
            }

            let candidate = value as! AXUIElement
            guard let candidateTitle = copyStringAttribute("AXTitle", from: candidate),
                  let candidatePosition = copyCGPointAttribute("AXPosition", from: candidate),
                  let candidateSize = copyCGSizeAttribute("AXSize", from: candidate) else {
                continue
            }

            if candidateTitle == window.title,
               Int(candidatePosition.x) == Int(window.frame.minX),
               Int(candidatePosition.y) == Int(window.frame.minY),
               Int(candidateSize.width) == Int(window.frame.width),
               Int(candidateSize.height) == Int(window.frame.height) {
                return candidate
            }
        }

        return nil
    }

    private func copyArrayAttribute(_ attribute: String, from element: AXUIElement) -> [CFTypeRef]? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)

        guard result == .success,
              let value,
              CFGetTypeID(value) == CFArrayGetTypeID() else {
            return nil
        }

        return value as? [CFTypeRef]
    }

    private func copyStringAttribute(_ attribute: String, from element: AXUIElement) -> String? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)

        guard result == .success, let value else {
            return nil
        }

        return value as? String
    }

    private func copyCGPointAttribute(_ attribute: String, from element: AXUIElement) -> CGPoint? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)

        guard result == .success,
              let value,
              CFGetTypeID(value) == AXValueGetTypeID() else {
            return nil
        }

        var point = CGPoint.zero
        guard AXValueGetValue(value as! AXValue, .cgPoint, &point) else {
            return nil
        }

        return point
    }

    private func copyCGSizeAttribute(_ attribute: String, from element: AXUIElement) -> CGSize? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)

        guard result == .success,
              let value,
              CFGetTypeID(value) == AXValueGetTypeID() else {
            return nil
        }

        var size = CGSize.zero
        guard AXValueGetValue(value as! AXValue, .cgSize, &size) else {
            return nil
        }

        return size
    }

    private func setCGPointAttribute(_ attribute: String, on element: AXUIElement, to point: CGPoint) -> Bool {
        var mutablePoint = point
        guard let value = AXValueCreate(.cgPoint, &mutablePoint) else {
            return false
        }

        return AXUIElementSetAttributeValue(element, attribute as CFString, value) == .success
    }

    private func setCGSizeAttribute(_ attribute: String, on element: AXUIElement, to size: CGSize) -> Bool {
        var mutableSize = size
        guard let value = AXValueCreate(.cgSize, &mutableSize) else {
            return false
        }

        return AXUIElementSetAttributeValue(element, attribute as CFString, value) == .success
    }
}
