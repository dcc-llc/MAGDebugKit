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
            url: "https://github.com/dcc-llc/MAGDebugKit/releases/download/0.9.6/MAGDebugKit-0.9.6.xcframework.zip",
            checksum: "2e2c0d0442e2e7886e0307da35064bfcd6a089600beb74b9738e78a07d0d4d20"
        ),
    ]
)