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
- Detect managed-window set changes during Refresh before adding background
  window watching.

Next success criteria:

Open or close a managed window, press Refresh, and Janus either reapplies the
managed layout when Auto Reflow is enabled or explains the manual path when Auto
Reflow is disabled.
