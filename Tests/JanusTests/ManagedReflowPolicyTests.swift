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

    func testDisabledPolicyDoesNotRefreshForWorkspaceEvents() {
        let policy = ManagedReflowPolicy(isEnabled: false)

        XCTAssertFalse(policy.shouldRefreshForWorkspaceEvent())
    }

    func testEnabledPolicyRefreshesForWorkspaceEvents() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertTrue(policy.shouldRefreshForWorkspaceEvent())
    }

    func testWindowSetDecisionRecordsBaselineBeforeBaselineExists() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertEqual(
            policy.decisionForWindowSetChange(previousKeys: nil, currentKeys: ["Finder|Downloads"]),
            .baselineRecorded
        )
    }

    func testWindowSetDecisionReportsNoManagedWindowsWhenCurrentSetIsEmpty() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertEqual(
            policy.decisionForWindowSetChange(previousKeys: ["Finder|Downloads"], currentKeys: []),
            .noManagedWindows
        )
    }

    func testWindowSetDecisionReportsUnchangedSet() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertEqual(
            policy.decisionForWindowSetChange(
                previousKeys: ["Finder|Downloads", "Safari|Janus"],
                currentKeys: ["Finder|Downloads", "Safari|Janus"]
            ),
            .unchanged
        )
    }

    func testWindowSetDecisionNotifiesWhenSetChangesAndAutoReflowIsDisabled() {
        let policy = ManagedReflowPolicy(isEnabled: false)

        XCTAssertEqual(
            policy.decisionForWindowSetChange(
                previousKeys: ["Finder|Downloads"],
                currentKeys: ["Finder|Downloads", "Safari|Janus"]
            ),
            .notify
        )
    }

    func testWindowSetDecisionReflowsWhenSetChangesAndAutoReflowIsEnabled() {
        let policy = ManagedReflowPolicy(isEnabled: true)

        XCTAssertEqual(
            policy.decisionForWindowSetChange(
                previousKeys: ["Finder|Downloads"],
                currentKeys: ["Finder|Downloads", "Safari|Janus"]
            ),
            .reflow
        )
    }
}
