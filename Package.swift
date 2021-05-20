// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sr25519",
    products: [
        .library(
            name: "Sr25519",
            targets: ["Sr25519"]),
        .library(
            name: "Ed25519",
            targets: ["Ed25519"])
    ],
    dependencies: [
        .package(url: "https://github.com/tesseract-one/UncommonCrypto.swift.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Sr25519",
            dependencies: ["CSr25519", "Sr25519Helpers"]),
        .target(
            name: "Ed25519",
            dependencies: ["CSr25519", "Sr25519Helpers"]),
        .target(
            name: "CSr25519",
            dependencies: ["CUncommonCrypto"],
            cSettings: [
                .define("ED25519_CUSTOMRANDOM"),
                .define("ED25519_CUSTOMHASH"),
                .define("ED25519_NO_INLINE_ASM"),
                .define("SR25519_CUSTOMHASH"),
                .headerSearchPath("src"),
                .headerSearchPath("src/ed25519-donna")
            ]
        ),
        .target(
            name: "Sr25519Helpers",
            dependencies: ["CSr25519"]),
        .testTarget(
            name: "Sr25519Tests",
            dependencies: ["Sr25519"]),
        .testTarget(
            name: "Ed25519Tests",
            dependencies: ["Ed25519"])
    ]
)
