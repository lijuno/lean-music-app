// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "LeanMusicApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "LeanMusicApp", targets: ["LeanMusicApp"])
    ],
    targets: [
        .target(
            name: "LeanMusicCore",
            path: "Sources/LeanMusicCore"
        ),
        .executableTarget(
            name: "LeanMusicApp",
            dependencies: ["LeanMusicCore"],
            path: "Sources/LeanMusicApp"
        ),
        .executableTarget(
            name: "LeanMusicAppChecks",
            dependencies: ["LeanMusicCore"],
            path: "Tests/LeanMusicAppChecks"
        )
    ]
)
