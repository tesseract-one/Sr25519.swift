// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if LOCALBINARY
    let useLocalBinary = true
#else
    let useLocalBinary = false
#endif

var package = Package(
    name: "Sr25519",
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
        .target(
            name: "CSr25519",
            dependencies: [],
            linkerSettings: [.linkedLibrary("sr25519crust")])
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
                checksum: "0c513d764300e17f99aaeb0ee117b1d1fb209245733af384776ab32e21ce5a74")
        )
    }
#endif
