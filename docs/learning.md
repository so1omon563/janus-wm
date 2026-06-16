# Learning Process

Janus is intentionally a learning project as well as a macOS application.

The project should help its maintainer build confidence with Swift, SwiftUI,
Xcode, and native macOS APIs while still making concrete progress toward the
window manager MVP.

## Principles

- Teach in context.
- Prefer small, reviewable changes.
- Explain new concepts when they first appear.
- Avoid unexplained generated code.
- Favor clear names and straightforward structure.
- Capture project-specific lessons in docs when they will help future work.

## Working Style

When adding source code, include enough explanation for a Swift or Xcode
beginner to understand the role of each new file.

When introducing a new platform concept, explain:

- What problem it solves
- Why Janus needs it
- Where it fits in the architecture
- Any macOS-specific constraints or surprises

Examples include:

- SwiftUI app entry points
- Views and state
- Xcode projects, targets, schemes, and signing
- Accessibility permissions
- `AXUIElement`
- Window discovery
- Window movement and resizing
- Persistence of user choices

## Code Expectations

Code should stay simple enough to learn from.

Abstractions are welcome when they clarify the project, but not when they hide
important platform behavior too early.

Prefer direct, readable implementations during the MVP. Refactor once the
primitive behavior is understood and reliable.

## Documentation Expectations

If a decision is mostly product-facing, document it in the roadmap, vision, or
principles docs.

If a decision is mostly implementation-facing, document it in architecture docs
or near the relevant code.

If a lesson is likely to help future contributors understand Swift, SwiftUI,
Xcode, or macOS Accessibility APIs in the context of Janus, document it here or
link to a more specific doc.
