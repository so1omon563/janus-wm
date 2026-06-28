# Principles

This is a living document. Principles describe how Janus should act on its
beliefs.

## Complement macOS

Janus should feel like it belongs beside existing macOS behavior. It should not
ask users to replace their mental model of the system before the app becomes
useful.

## Preserve User Intent

Manual user actions are authoritative. Automation may help, but it should remain
visible, reversible, and overridable.

## Communicate Intent, Not Implementation

Janus should explain what it is doing in terms of the user's work, not its
internal machinery. "Managed" and "Floating" are useful only when they help the
user understand what will happen next.

## Opinionated By Default. Flexible By Choice.

The default experience should make a clear recommendation. Flexibility should be
available when the recommendation does not fit, but it should not be required
before Janus becomes useful.

## Minimal Configuration

Configuration is a last resort. Reasonable defaults should solve common work
without requiring TOML, YAML, scripting, or a rule engine.

## Defaults Should Solve Real Work

A default is good when it removes repeated decisions from common work. It is bad
when it merely reflects what was easy to implement.

## Visibility Is A Scarce Resource

Every visible control competes with the user's actual work. Janus should show
what matters now and keep deeper capabilities discoverable without crowding the
surface.

## Every Capability Should Be Discoverable

Hidden power is still friction. If Janus can do something, the user should be
able to find it through the app's normal interaction model.

## Reduce Cognitive Tax

Features should reduce the number of things a user must remember, repeat, or
reconstruct before work can continue.

## Optimize For Cognitive Continuity

Janus should prefer stable, understandable changes over aggressive reflow. The
best layout is often the one that lets the user keep thinking.

## Move Windows Predictably

Window movement should be calm and explainable. Janus should avoid unnecessary
reflow, and when it does move a window, the reason should be visible from the
current interaction.

## Reduce Toil, Not Capability

Janus should remove repetitive manual effort without trapping users in a narrow
workflow. Automation is useful when it serves user intent and remains
overridable.

## Good Defaults Are Earned

Defaults should become stronger as the project gathers evidence. Guessing early
and adding configuration to cover every case is not the same as learning.

## Every Abstraction Deserves An Escape Hatch

Contexts, layouts, and automation should help until they do not. When Janus gets
something wrong, the user needs a clear way to correct it.

## Optimize For The User's Mental Model

The system may think in windows, screens, frames, and Accessibility elements.
The user thinks in tasks, interruptions, and resuming work. The user model wins.

## Reduce Time To Mental Productivity

Every design decision should reduce the time required for someone to become
mentally productive again. This is the test that keeps Janus from becoming a
collection of window-management tricks.
