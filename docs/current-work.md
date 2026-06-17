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
- Prove Auto Reflow with real windows after refresh and tile/float changes.
- Avoid background window watching until the manual and opt-in behavior feels
  reliable.

Next success criteria:

Open or close a managed window, refresh the list, and Janus reapplies the
managed layout when Auto Reflow is enabled.
