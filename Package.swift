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
            checksum: "4bbba5bb69dd76352edec72c0ab51677b3af8cb38fe83795c311635337d377dc"
        ),
    ]
)