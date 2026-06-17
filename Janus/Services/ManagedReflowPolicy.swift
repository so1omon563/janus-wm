struct ManagedReflowPolicy {
    var isEnabled: Bool

    func shouldReflow(managedWindowCount: Int) -> Bool {
        isEnabled && managedWindowCount > 0
    }
}
