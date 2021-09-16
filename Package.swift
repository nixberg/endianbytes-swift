// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "endianbytes-swift",
    products: [
        .library(
            name: "EndianBytes",
            targets: ["EndianBytes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "EndianBytes",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
        .testTarget(
            name: "EndianBytesTests",
            dependencies: ["EndianBytes"]),
    ]
)
