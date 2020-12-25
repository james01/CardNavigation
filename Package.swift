// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CardNavigation",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "CardNavigation",
            targets: ["CardNavigation"]),
    ],
    targets: [
        .target(
            name: "CardNavigation",
            dependencies: []),
        .testTarget(
            name: "CardNavigationTests",
            dependencies: ["CardNavigation"]),
    ]
)
