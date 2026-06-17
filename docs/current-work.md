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

Next success criteria:

Choose the first low-surprise path for noticing window changes without requiring
manual Refresh every time.
