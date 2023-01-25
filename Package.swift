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
            url: "https://github.com/dcc-llc/MAGDebugKit/releases/download/0.9.5/MAGDebugKit-0.9.5.xcframework.zip",
            checksum: "e9a284d19fb2583cd76c98e3dc5f77235cca4f187985d0369d9a2b1b143ca2f6"
        ),
    ]
)