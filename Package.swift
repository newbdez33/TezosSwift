// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TezosSwift",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TezosSwift",
            targets: ["TezosSwift"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/attaswift/BigInt", 
            from: "5.2.0"
        ),
        .package(
            url: "https://github.com/newbdez33/MnemonicKit", 
            from: "1.3.21"
        ),
        .package(
            url: "https://github.com/jedisct1/swift-sodium", 
            from: "0.9.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TezosSwift",
            dependencies: ["BigInt", "MnemonicKit", "Sodium"]),
        .testTarget(
            name: "TezosSwiftTests",
            dependencies: ["TezosSwift"]),
    ]
)
