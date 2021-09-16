// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "endianbytes-swift",
    products: [
        .library(
            name: "EndianBytes",
            targets: ["EndianBytes"]),
    ],
    targets: [
        .target(
            name: "EndianBytes",
            dependencies: []),
        .testTarget(
            name: "EndianBytesTests",
            dependencies: ["EndianBytes"]),
    ]
)
