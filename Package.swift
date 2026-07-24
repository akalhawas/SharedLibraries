// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedLibraries",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "Core",
            targets: ["Core"]
        ),
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    targets: [
        .target(
            name: "Navigation"
        ),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"]
        ),
        .target(
            name: "NetworkService"
        ),
        .target(
            name: "DesignSystem"
        ),
        .target(
            name: "Core"
        ),
        .target(
            name: "Utilities"
        ),
    ]
)
