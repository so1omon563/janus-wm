import CoreGraphics
import Foundation

struct WindowInfo: Identifiable, Hashable {
    let id: String
    let appName: String
    let appIdentifier: String
    let processIdentifier: pid_t
    let title: String
    let frame: CGRect

    var displayTitle: String {
        title.isEmpty ? "Untitled Window" : title
    }

    var frameSummary: String {
        "\(Int(frame.width)) x \(Int(frame.height)) at \(Int(frame.minX)), \(Int(frame.minY))"
    }

    var stateKey: String {
        "\(appIdentifier)|\(displayTitle)"
    }
}
