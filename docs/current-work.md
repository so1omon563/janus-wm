# Current Work

## Current Milestone

Janus has the core window-control primitives in place:

1. Request Accessibility permissions
2. Enumerate visible application windows
3. Present a list of windows
4. Move and resize a selected window
5. Persist floating/tiled state
6. Apply a first horizontal managed layout
7. Reapply managed layout through an opt-in Auto Reflow toggle

Current focus:

- Keep managed layout behavior explicit and reversible.
- Auto Reflow has been manually verified with real windows after refresh and
  tile/float changes.
- Managed-window set changes during Refresh have been manually verified with
  Auto Reflow enabled and disabled.
- Workspace app launch, terminate, and activation events now trigger the same
  managed-window set check only when Auto Reflow is enabled, and this behavior
  has been manually verified.
- Reflow diagnostics now use the existing status line to explain baseline,
  no-change, manual-path, and automatic-layout outcomes.

Next success criteria:

Verify the status line explains why Janus did or did not reapply layout before
moving to richer design work.
