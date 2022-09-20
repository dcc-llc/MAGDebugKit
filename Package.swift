// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MAGDebugKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "MAGDebugKit",
            targets: ["MAGDebugKit"]),
    ],
    dependencies: [ ],
    targets: [
        .binaryTarget(
            name: "MAGDebugKit",
            url: "https://github.com/dcc-llc/MAGDebugKit/releases/download/0.9.4/MAGDebugKit-0.9.4.xcframework.zip",
            checksum: "a02910f1d46facec77e628ef62c2d8c7e5a4fc7c35717bfb8748ed7413fdaac9"
        ),
    ]
)