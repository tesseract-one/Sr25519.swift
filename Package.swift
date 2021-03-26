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
                url: "https://github.com/tesseract-one/sr25519.swift/releases/download/0.0.1/CSr25519.SPM-Binary.zip",
                checksum: "47c8e400b6d1c0f15e8c0324a684446cfcf4aa854b5d2eb540e4d4688442b8a0")
        )
    }
#endif
