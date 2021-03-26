// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let useLocalBinary = false

var package = Package(
    name: "Sr25519",
    platforms: [.iOS(.v11), .macOS(.v10_12), .tvOS(.v11)],
    products: [
        .library(
            name: "Sr25519",
            targets: ["Sr25519"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Sr25519",
            dependencies: ["CSr25519"]),
        .testTarget(
            name: "Sr25519Tests",
            dependencies: ["Sr25519"])
    ]
)

#if os(Linux)
    package.targets.append(
        .systemLibrary(name: "CSr25519")
    )
#else
    if useLocalBinary {
        package.targets.append(
            .binaryTarget(
                name: "CSr25519",
                path: "binaries/CSr25519.xcframework")
        )
    } else {
        package.targets.append(
            .binaryTarget(
                name: "CSr25519",
                url: "https://github.com/tesseract-one/sr25519.swift/releases/download/0.0.2/CSr25519.binaries.zip",
                checksum: "30046d420324635894d1ed94a6f077846a9cf2cad27f235ec883cee3ac743037")
        )
    }
#endif
