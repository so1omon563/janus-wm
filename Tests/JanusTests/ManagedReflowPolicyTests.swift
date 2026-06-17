import XCTest
@testable import Janus

final class ManagedReflowPolicyTests: XCTestCase {
    func testDisabledPolicyDoesNotReflowManagedWindows() {
        let policy = ManagedReflowPolicy(isEnabled: false)

        XCTAssertFalse(policy.shouldReflow(managedWindowCount: 2))
    }

    func testEnabledPolicyDoesNotReflowWhenThereAreNoManagedWindows() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertFalse(policy.shouldReflow(managedWindowCount: 0))
    }

    func testEnabledPolicyReflowsWhenManagedWindowsExist() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertTrue(policy.shouldReflow(managedWindowCount: 1))
    }
}
