// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "endianbytes-swift",
    products: [
        .library(
            name: "EndianBytes",
            targets: [
                "EndianBytes",
                "EndianBytesConvertible",
                "EndianBytesSIMD",
            ]),
    ],
    targets: [
        .target(
            name: "EndianBytes",
            dependencies: ["EndianBytesConvertible"]),
        .target(
            name: "EndianBytesConvertible"),
        .target(
            name: "EndianBytesSIMD",
            dependencies: ["EndianBytesConvertible"]),
        .testTarget(
            name: "EndianBytesTests",
            dependencies: ["EndianBytes"]),
        .testTarget(
            name: "EndianBytesSIMDTests",
            dependencies: ["EndianBytesSIMD"]),
    ]
)
