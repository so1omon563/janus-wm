import CoreGraphics
import XCTest
@testable import Janus

final class LayoutEngineTests: XCTestCase {
    func testHorizontalFramesReturnsNoFramesForNoWindows() {
        let engine = LayoutEngine()

        XCTAssertEqual(engine.horizontalFrames(count: 0, in: CGRect(x: 0, y: 0, width: 1000, height: 800)), [])
    }

    func testHorizontalFramesSplitsBoundsWithMarginsAndGap() {
        let engine = LayoutEngine(margin: 10, gap: 20)
        let frames = engine.horizontalFrames(
            count: 2,
            in: CGRect(x: 0, y: 34, width: 1000, height: 700)
        )

        XCTAssertEqual(frames.count, 2)
        XCTAssertEqual(frames[0], CGRect(x: 10, y: 44, width: 480, height: 680))
        XCTAssertEqual(frames[1], CGRect(x: 510, y: 44, width: 480, height: 680))
    }

    func testHorizontalFramesKeepsMinimumSizeForSmallBounds() {
        let engine = LayoutEngine(margin: 10, gap: 20)
        let frames = engine.horizontalFrames(
            count: 2,
            in: CGRect(x: 0, y: 0, width: 400, height: 300)
        )

        XCTAssertEqual(frames[0].width, 300)
        XCTAssertEqual(frames[0].height, 360)
    }
}
