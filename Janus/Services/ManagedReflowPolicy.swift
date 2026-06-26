enum ManagedReflowDecision: Equatable {
    case baselineRecorded
    case noManagedWindows
    case unchanged
    case notify
    case reflow
}

struct ManagedReflowPolicy {
    var isEnabled: Bool

    func shouldReflow(managedWindowCount: Int) -> Bool {
        isEnabled && managedWindowCount > 0
    }

    func shouldRefreshForWorkspaceEvent() -> Bool {
        isEnabled
    }

    func decisionForWindowSetChange(previousKeys: Set<String>?, currentKeys: Set<String>) -> ManagedReflowDecision {
        guard !currentKeys.isEmpty else {
            return .noManagedWindows
        }

        guard let previousKeys else {
            return .baselineRecorded
        }

        guard previousKeys != currentKeys else {
            return .unchanged
        }

        return isEnabled ? .reflow : .notify
    }
}
