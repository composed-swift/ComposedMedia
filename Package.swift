// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ComposedMedia",
    platforms: [
        .iOS(.v11)

    ],
    products: [
        .library(
            name: "ComposedMedia",
            targets: ["ComposedMedia"]),
    ],
    dependencies: [
        .package(url: "https://github.com/composed-swift/Composed", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "ComposedMedia",
            dependencies: ["Composed"]),
    ]
)
