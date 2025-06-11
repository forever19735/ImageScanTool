// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "ImageScanTool",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "imagescan", targets: ["ImageScanTool"]),
        .library(name: "ImageScanCore", targets: ["ImageScanCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
    ],
    targets: [
        .target(
            name: "ImageScanCore",
            dependencies: []
        ),
        .executableTarget(
            name: "ImageScanTool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ImageScanCore"
            ]
        ),
        .testTarget(
            name: "ImageScanToolTests",
            dependencies: ["ImageScanCore"],
            path: "Tests/ImageScanToolTests"
        ),
    ]
)
