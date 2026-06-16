Janus

Janus is a native macOS window manager focused on effortless tiling without sacrificing the flexibility of floating windows.

Inspired by Pop!_OS and Hyprland, Janus aims to bring modern tiling workflows to macOS while remaining approachable for users who do not want to manage large configuration files or memorize dozens of keyboard shortcuts.

Goals

* Automatic tiling
* Floating and tiled windows living side-by-side
* Native macOS user experience
* Minimal configuration
* Visual feedback and polish
* No SIP modifications
* No private APIs

Status

Early development.

Current focus is establishing reliable window discovery and manipulation through macOS Accessibility APIs.

MVP

* Request Accessibility permissions
* Enumerate visible windows
* Display available windows
* Move and resize windows
* Persist floating/tiled state
* Toggle tile/float mode

Technology

* Swift
* SwiftUI
* AXUIElement Accessibility APIs

Philosophy

Janus prioritizes usability over configurability.

If forced to choose between a simpler user experience and a more powerful configuration system, the simpler user experience should generally win for the MVP.

Project Structure

docs/
vision.md
architecture.md
current-work.md
decisions.md
roadmap.md

Janus/
Application source code

Name

Janus is named after the Roman god of transitions, gateways, and duality.

The name reflects the ability to move naturally between floating and tiled workflows without forcing users into one approach.
