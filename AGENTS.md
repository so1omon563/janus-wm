# AGENTS.md

## Read First

Before making changes:

1. Read AGENTS.md
2. Read docs/vision.md
3. Follow AGENTS.md if there is any conflict

---

## Project Goal

Janus is a native macOS window manager.

Primary goal:

- Effortless tiling
- First-class floating windows
- Native macOS experience

Non-goals:

- AeroSpace clone
- i3 clone
- Complex rule engine
- Configuration-heavy workflows

---

## Priorities

When making decisions, optimize in this order:

1. Reliability
2. Simplicity
3. User control
4. Discoverability
5. Performance
6. Flexibility

---

## Principles

### User Intent > Layout Correctness

Manual user actions are authoritative.

### Simplicity > Configurability

Do not add configuration when a reasonable default exists.

### Native > Clever

Prefer macOS conventions over cross-platform abstractions.

### User Control > Automation

Automatic behavior must be overridable.

### Stability > Reflow

Avoid moving windows unnecessarily.

### Floating Windows Are First-Class

Floating windows are not exceptions.

### Mouse And Keyboard Are Equal

Do not require keyboard-driven workflows.

### Visual Feedback Is Required

Users should understand why a window moved.

---

## Technical Constraints

- Use public Apple APIs.
- Do not require SIP changes.
- Prefer Accessibility APIs.
- Build reliable primitives before advanced features.

---

## Current MVP

1. Accessibility permissions
2. Window discovery
3. Window selection UI
4. Move/resize windows
5. Persist state
6. Tile/float toggle

Do not prioritize advanced layouts before MVP is reliable.

---

## Feature Evaluation

Before implementing a feature ask:

- Does it reduce complexity?
- Does it preserve user intent?
- Does it feel native on macOS?
- Is it discoverable?
- Is configuration required?

If multiple solutions exist, choose the simpler one.
