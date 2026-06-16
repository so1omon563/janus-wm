// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "JanusWM",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "Janus",
            targets: ["Janus"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Janus",
            path: "Janus"
        )
    ]
)
