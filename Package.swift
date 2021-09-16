// swift-tools-version:5.5

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
