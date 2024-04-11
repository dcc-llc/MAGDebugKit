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
            url: "https://github.com/dcc-llc/MAGDebugKit/releases/download/0.9.8/MAGDebugKit-signed.xcframework.zip",
            checksum: "c2255d41e05e095054694ba30023ff4e82dd0b7398ff8e8e4b1712c30c58a67d"
        ),
    ]
)
