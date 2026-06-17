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

## First App Scaffold

Janus starts as a Swift Package that builds one macOS SwiftUI executable named
`Janus`.

The first source files are intentionally split by role:

- `Janus/App/JanusApp.swift` owns the SwiftUI app entry point.
- `Janus/Views/ContentView.swift` owns the first visible window.
- `Janus/Services/AccessibilityManager.swift` owns the macOS Accessibility
  permission check.

SwiftUI's `App` type is the modern entry point for a macOS app. The
`WindowGroup` scene creates the main Janus window, and the app delegate calls
AppKit APIs that make the SwiftPM-built app behave like a foreground Mac app.

## Accessibility Permission

macOS protects window discovery and window movement behind Accessibility
permission. Janus needs that permission before it can use Accessibility APIs
such as `AXUIElement` to inspect or control other application windows.

The first implementation uses:

- `AXIsProcessTrusted()` to check whether Janus already has permission.
- `AXIsProcessTrustedWithOptions(...)` to ask macOS to show the permission
  prompt.
- `NSWorkspace.shared.open(...)` to open the Accessibility pane in System
  Settings.

This does not enumerate or move windows yet. It establishes the reliable
permission primitive that every later MVP step depends on.

## Window Discovery

Window discovery is the next primitive after Accessibility permission.

Janus asks `NSWorkspace` for running foreground applications, creates an
Accessibility element for each app with `AXUIElementCreateApplication(...)`,
then reads the app's `AXWindows` attribute. Each returned window is another
Accessibility element.

For this first version, Janus reads only display-safe facts:

- `AXTitle` for the window title.
- `AXPosition` for the window's top-left point.
- `AXSize` for the window's dimensions.

Janus stores those facts in `WindowInfo` instead of keeping live window handles
in the UI. That keeps the first discovery milestone easy to inspect before the
project starts moving or resizing windows.

## Window Selection

The first selection workflow is intentionally display-only. `ContentView` keeps
the selected row ID in local `@State`, then looks up the matching `WindowInfo`
from the latest `WindowTracker.windows` array.

This keeps selection window-scoped and temporary. Janus does not persist a
selected window because windows can disappear, change titles, or move outside of
Janus. If a refresh no longer contains the selected ID, the selection is cleared.

Janus also filters its own process out of discovery. That avoids offering a
future move/resize action against the Janus control window itself during normal
MVP workflows.

## Window Movement

The first movement workflow is a manual test action, not tiling. A user selects
one discovered window, then presses `Move to Test Frame`.

Janus reconnects the selected `WindowInfo` value to a live Accessibility window
by looking up the selected process and matching the window's title, position,
and size. This avoids keeping live `AXUIElement` references in SwiftUI state.

The movement itself uses:

- `AXValueCreate(.cgPoint, ...)` to wrap a new top-left point.
- `AXValueCreate(.cgSize, ...)` to wrap a new size.
- `AXUIElementSetAttributeValue(..., "AXPosition", ...)` to move the window.
- `AXUIElementSetAttributeValue(..., "AXSize", ...)` to resize the window.

This is intentionally conservative. If the selected window changed or
disappeared before the button press, Janus asks the user to refresh and select it
again instead of guessing.

The first restore workflow is also temporary. `ContentView` stores the selected
window's frame in local `@State` before the first test move, then enables
`Restore Frame` for that window. This gives the user a quick escape hatch while
Janus is still proving its movement primitive. It is not durable persistence yet;
that belongs to the next MVP step.

## Persisted Window Intent

The first durable state is the user's window intent: `Floating` or `Managed`.
This does not tile windows yet. It only records whether the user wants Janus to
treat a window as part of the future managed layout.

`WindowStateStore` persists this mode in `UserDefaults`. The key is built from
the app identity and window title rather than process ID, because process IDs
change every time an app relaunches. This is a reasonable first MVP identity,
but it is not perfect:

- Two windows from the same app can have the same title.
- A document window title can change as the document changes.
- Some apps expose untitled or unstable Accessibility titles.

Janus starts with this simple identity because it keeps the behavior easy to
understand while the project learns which windows need stronger matching.

## First Managed Layout

The first managed layout is explicit. A user marks windows as `Managed`, then
presses `Apply Managed Layout`. Janus does not automatically reflow windows yet.

The first layout is a horizontal split across the main display. It calculates
one frame per managed window with simple margins and gaps, then moves only those
managed windows through the same Accessibility movement primitive used by
`Move to Test Frame`.

The layout uses the main `NSScreen.visibleFrame` rather than the raw display
bounds. `visibleFrame` excludes the menu bar and Dock, which makes the default
placement feel closer to native macOS window behavior. AppKit reports screen
frames in a bottom-left coordinate space, while Accessibility window positions
use a top-left coordinate space, so Janus converts the visible frame before
passing it to `AXUIElement`.

Before moving each managed window, Janus caches that window's previous frame in
the temporary restore state. This keeps the first layout action reversible while
the project is still proving the primitive behavior.

## Layout Engine Extraction

Once the horizontal split worked in real use, Janus moved the frame calculation
out of `ContentView` and into `LayoutEngine`.

`LayoutEngine` is intentionally a pure calculation type. It receives a window
count and layout bounds, then returns the frames Janus should apply. It does not
know about SwiftUI, Accessibility permission, or live `AXUIElement` windows.
That separation lets the project test layout behavior without moving real
windows.

The first tests cover:

- No frames when there are no managed windows.
- Even horizontal splitting with margins and gaps.
- Minimum tile sizes when the available bounds are too small.

## Automatic Managed Reflow

The first automatic layout behavior is still opt-in. Janus adds an `Auto Reflow`
toggle near the existing `Apply Managed Layout` action.

When enabled, Janus reapplies the managed layout after refreshing the visible
window list or after changing a selected window between `Floating` and
`Managed`. This keeps the behavior discoverable and reversible while the project
is still proving the window movement primitive.

The toggle uses SwiftUI's `@AppStorage`, which stores a simple user preference
in `UserDefaults`. This is a good fit for small app-wide preferences because
SwiftUI updates the view when the value changes and persists it across launches.

`ManagedReflowPolicy` owns the small decision of whether a reflow should happen.
It stays separate from SwiftUI and Accessibility so the policy can be tested
without moving real windows.

## Local Accessibility Trust And Signing

macOS Accessibility permission is tied to the app's code identity. During local
SwiftPM development, Janus stages a `.app` bundle in `dist/Janus.app` and signs
that bundle after writing its `Info.plist`.

The run script also supports `--launch-existing`, which opens the already staged
bundle without rebuilding it. This is useful while debugging Accessibility
permission, because rebuilding can change an ad hoc signature and make macOS
treat the app as a different trust record.
