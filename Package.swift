// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MAGDebugKit",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "MAGDebugKit",
            targets: ["MAGDebugKit"]),
    ],
    dependencies: [ ],
    targets: [
        .binaryTarget(
            name: "MAGDebugKit",
            url: "https://github.com/dcc-llc/MAGDebugKit/releases/download/0.9.3/MAGDebugKit-0.9.3.xcframework.zip",
            checksum: "ae6f0c4958677eb4f80ac74def4d3648367343cafef7bdf90a26bbe7fd1fd67a"
        ),
    ]
)