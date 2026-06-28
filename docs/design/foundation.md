# Janus Design Foundation

This document records confirmed Janus product and design decisions. It should
not invent new direction; unresolved ideas belong under Open Questions until a
human decision records them.

## Confirmed Decisions

- Product name: Janus.
- Internal/package name: JanusWM.
- Positioning: thoughtful macOS window manager.
- Audience: the middle space between casual Mac users and power users.
- Philosophy: reduce window-management friction without forcing a new way of
  working.
- Product posture: complement macOS, not replace it.
- Technical posture: use public macOS APIs, especially Accessibility APIs; do
  not require SIP changes or invasive hacks.

## Product Shape

Janus should make tiling approachable without becoming a configuration-heavy
power-user tool. It should favor native behavior, calm defaults, progressive
discovery, minimal configuration, and predictable window movement.

Janus should feel like a Mac app first and a tiling window manager second.
Floating and managed windows are both first-class workflows.

## Human And Codex Working Model

Human product judgment owns Janus direction: product philosophy, UX decisions,
naming, visual language, interaction language, and changes to positioning.

Codex may own implementation proposals, diffs, repo maintenance, GitHub issue
grooming, PR preparation, documentation normalization, and consistency checks.

Codex must not silently introduce new product direction. When a product, UX,
naming, visual, or interaction choice would change direction, Codex should
propose it explicitly and record the accepted decision in `docs/design` or
`docs/decisions.md` before implementation.

## Open Questions

- What should the polished Janus onboarding flow be?
- What visual feedback should Janus use beyond the current status line?
- Which layout controls belong in the default surface, and which should remain
  discoverable deeper in the app?
