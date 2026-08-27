// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "YTMusicApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "YTMusicApp", targets: ["YTMusicApp"])
    ],
    targets: [
        .target(
            name: "YTMusicCore",
            path: "Sources/YTMusicCore"
        ),
        .executableTarget(
            name: "YTMusicApp",
            dependencies: ["YTMusicCore"],
            path: "Sources/YTMusicApp"
        ),
        .executableTarget(
            name: "YTMusicAppChecks",
            dependencies: ["YTMusicCore"],
            path: "Tests/YTMusicAppChecks"
        )
    ]
)
