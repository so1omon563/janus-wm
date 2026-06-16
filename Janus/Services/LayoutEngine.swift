import CoreGraphics

struct LayoutEngine {
    var margin: CGFloat = 12
    var gap: CGFloat = 12
    var minimumWindowWidth: CGFloat = 300
    var minimumWindowHeight: CGFloat = 360

    func horizontalFrames(count: Int, in layoutBounds: CGRect) -> [CGRect] {
        guard count > 0 else {
            return []
        }

        let totalGap = gap * CGFloat(max(count - 1, 0))
        let availableWidth = max(minimumWindowWidth * CGFloat(count), layoutBounds.width - (margin * 2) - totalGap)
        let availableHeight = max(minimumWindowHeight, layoutBounds.height - (margin * 2))
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
}
