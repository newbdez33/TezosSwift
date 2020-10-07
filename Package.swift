// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TezosSwift",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v9)//,
    ],
    products: [
        .library(
            name: "TezosSwift",
            targets: ["TezosSwift"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift", 
            from: "1.3.2"
        ),
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
            from: "0.8.0"
        ),
    ],
    targets: [
        .target(
            name: "TezosSwift",
            dependencies: ["CryptoSwift", "BigInt", "MnemonicKit", "swift-sodium"],
            path: "TezosSwift",
            exclude: ["Info.plist"]),
    ]
)