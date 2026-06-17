enum ManagedReflowDecision: Equatable {
    case none
    case notify
    case reflow
}

struct ManagedReflowPolicy {
    var isEnabled: Bool

    func shouldReflow(managedWindowCount: Int) -> Bool {
        isEnabled && managedWindowCount > 0
    }

    func decisionForWindowSetChange(previousKeys: Set<String>?, currentKeys: Set<String>) -> ManagedReflowDecision {
        guard !currentKeys.isEmpty,
              let previousKeys,
              previousKeys != currentKeys else {
            return .none
        }

        return isEnabled ? .reflow : .notify
    }
}
