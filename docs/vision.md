Janus Vision

Overview

Janus is a native macOS window manager focused on effortless tiling without sacrificing the flexibility of floating windows.

The project is inspired by the workflow of Pop!_OS Auto Tiling and Hyprland, but aims to feel at home on macOS rather than importing Linux window management paradigms wholesale.

Janus exists because current macOS window management tools generally fall into one of two categories:

* Manual placement tools such as Rectangle and Magnet
* Powerful but highly configuration-driven tiling systems such as AeroSpace and yabai

Janus seeks a middle ground.

The goal is to provide automatic tiling that works immediately while preserving the flexibility and visual polish expected from a Mac application.

⸻

Product Name

Janus

Internal Name

JanusWM

⸻

Why Janus Exists

Many macOS users are interested in tiling window management but are discouraged by:

* Extensive configuration requirements
* Keyboard-shortcut overload
* Linux-centric workflows
* Complex rule systems
* Large TOML or YAML configuration files

Janus aims to eliminate as much of that friction as possible.

A user should be able to install Janus and immediately understand how it works without reading extensive documentation.

⸻

Core Philosophy

Configuration Is A Last Resort

Users should not be required to write configuration files to achieve common workflows.

Reasonable defaults should solve most use cases.

Configuration should be optional rather than mandatory.

Floating Windows Are First-Class Citizens

Many tiling managers treat floating windows as exceptions.

Janus treats floating and tiled windows as equally valid.

Examples of windows that commonly belong in floating mode:

* Music players
* Calculators
* Utility windows
* Dialog boxes
* Temporary reference material

Examples of windows that commonly belong in tiled mode:

* Browsers
* Terminals
* Editors
* IDEs
* Documentation

The user should be able to move between these modes effortlessly.

Mouse Workflows Matter

Janus should not assume every user wants to operate entirely from the keyboard.

Mouse-driven workflows should remain viable.

Keyboard shortcuts are useful, but should not be the primary identity of the application.

Native macOS Experience

Janus should feel like a Mac application.

The project should embrace macOS conventions whenever possible.

The experience should feel closer to:

* Rectangle
* Magnet
* Native macOS window management

Than to:

* i3
* bspwm
* sway

⸻

Design Goals

Minimal Configuration

The default experience should be useful immediately after installation.

Users should not need to create configuration files before Janus becomes valuable.

Tiling First

Windows should automatically participate in layouts when appropriate.

The system should proactively organize windows rather than requiring manual placement.

Float Or Tile Per Window

Every window should be able to exist in either mode.

The distinction should be simple and visible.

The operation:

Tile ↔ Float

should be one of the most important actions in the application.

Visual Feedback

Janus should communicate what it is doing.

Potential examples:

* Layout overlays
* Window highlighting
* Placement previews
* Smooth transitions

The application should feel polished rather than purely functional.

Predictable Behavior

Users should quickly develop an intuition for where windows will be placed.

Unexpected behavior should be avoided whenever possible.

⸻

Target User

The ideal Janus user:

* Uses macOS as their primary platform
* Likes the idea of tiling window management
* Wants productivity benefits without complexity
* Uses both keyboard and mouse
* May have previous Linux experience
* Values simplicity over endless customization

⸻

Technical Direction

Platform

* macOS
* Swift
* SwiftUI

Window Management

Janus will primarily rely on Accessibility APIs for window discovery and manipulation.

Key technologies include:

* AXUIElement
* Accessibility permissions

The project should avoid:

* SIP modifications
* Private APIs
* Unsupported system patches

Whenever possible, Janus should use stable, documented Apple APIs.

⸻

MVP

The first milestone is not a tiling manager.

The first milestone is a reliable window control platform.

Success criteria:

1. Request Accessibility permissions
2. Enumerate visible application windows
3. Display a list of available windows
4. Move and resize a selected window
5. Persist floating/tiled state
6. Toggle tile/float mode

If Janus cannot reliably discover and manipulate windows, no higher-level functionality matters.

⸻

Initial Layouts

The MVP should begin with a small number of layouts.

Potential candidates:

* Vertical stack
* Horizontal stack
* BSP layout

The project should resist the temptation to add large numbers of layout options early.

⸻

Non-Goals

The following items are explicitly out of scope for the initial release:

* Mission Control replacement
* Full workspace manager
* Extensive automation engine
* Scripting language
* Complex rule engine
* AeroSpace-level configurability
* Power-user-first workflows

These may be explored later if there is a compelling reason.

⸻

Inspirations

Positive Inspirations

* Pop!_OS Auto Tiling
* Hyprland
* Rectangle
* Magnet

Negative Inspirations

Not because they are bad tools, but because Janus is solving a different problem:

* Excessive configuration
* Keyboard-only workflows
* Complex startup requirements
* Large rule systems

⸻

Architectural Direction

Potential high-level structure:

JanusApp

* AccessibilityManager
* WindowTracker
* LayoutEngine
* TileManager
* FloatingManager
* OverlayRenderer
* SettingsManager

AccessibilityManager

Responsible for interacting with macOS Accessibility APIs.

WindowTracker

Maintains awareness of active windows and state changes.

LayoutEngine

Calculates layouts without directly manipulating windows.

TileManager

Applies layouts to managed windows.

FloatingManager

Tracks windows excluded from layout calculations.

OverlayRenderer

Provides visual feedback and placement indicators.

⸻

Success Criteria

Janus succeeds if a user can:

* Install the application
* Grant Accessibility permissions
* Open a few windows
* Press Tile
* Immediately understand what happened

without reading documentation, editing configuration files, or learning dozens of keyboard shortcuts.

If a tradeoff must be made between power and simplicity during the MVP phase, simplicity should win.
