# Glossary

## Janus

The product name for the macOS window manager.

## JanusWM

The internal/package name. Use this when the implementation needs a package or
module identity distinct from the product name.

## Thoughtful macOS window manager

Janus's positioning. It means Janus should reduce window-management friction
while preserving native macOS expectations, user control, and approachable
defaults.

## Managed

A window state where Janus may include the window in its layout calculations.
Managed does not mean Janus owns every future movement of that window.

## Floating

A window state where Janus should leave the window out of managed layout
calculations. Floating windows are first-class, not exceptions.

## Context

The meaningful work state a person is in or trying to recover. A context may
include windows, apps, documents, placement, intent, attention, and task
history, but it is not reducible to any one of them.

## Layout

The spatial arrangement of windows on screen. In Janus, a layout is an
implementation of context, not the product itself.

## Workspace

A bounded area of work where related windows and intentions can be made visible
or recoverable. The exact Janus meaning is still being discovered.

## Momentum

The user's ability to keep moving through work without repeatedly rebuilding
their mental state.

## Cognitive Tax

The extra mental effort required to resume, maintain, or switch work. Examples
include remembering where a window belongs, recreating an arrangement, or
decoding a surprising automatic action.

## Cognitive Continuity

The preservation of enough mental and visual state for work to continue after a
change, interruption, or transition.

## Visibility

What Janus puts directly in front of the user at a given moment. Visibility is
limited and should be used carefully.

## Discoverability

The ability to find a capability when it becomes relevant, even if it is not
always visible.

## Intent

The user's expressed or inferred purpose. Manual user actions are the strongest
signal of intent.

## Default

The behavior Janus chooses before the user customizes anything. A good default
is opinionated, understandable, and based on real use.

## Progressive Discovery

The design value that common actions should be obvious while deeper controls
become findable when they are relevant. Janus should not expose every possible
option all at once.

## Belief

A current explanation of why Janus should behave a certain way. Beliefs are
living and should change when evidence changes.

## Principle

A design rule derived from beliefs. Principles guide product and implementation
choices while allowing the project to evolve.

## RFC

An immutable historical design record. An RFC captures what Janus believed at
the moment it was written. Later understanding should be captured in a later
RFC, not by rewriting the original.
