// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "VideoCompressor",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "VideoCompressor",
            targets: ["VideoCompressor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/NextLevel/NextLevelSessionExporter.git", from: "0.4.3")
    ],
    targets: [
        .target(
            name: "VideoCompressor",
            dependencies: ["NextLevelSessionExporter"],
            path: "Sources/VideoCompressor")
    ]
)