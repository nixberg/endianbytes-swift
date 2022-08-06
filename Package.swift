// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "endianbytes-swift",
    products: [
        .library(
            name: "EndianBytes",
            targets: ["EndianBytes"]),
        .library(
            name: "SIMDEndianBytes",
            targets: ["SIMDEndianBytes"]),
    ],
    targets: [
        .target(
            name: "EndianBytes"),
        .target(
            name: "SIMDEndianBytes",
            dependencies: ["EndianBytes"]),
        .testTarget(
            name: "EndianBytesTests",
            dependencies: ["EndianBytes"]),
        .testTarget(
            name: "SIMDEndianBytesTests",
            dependencies: ["SIMDEndianBytes"]),
    ]
)
