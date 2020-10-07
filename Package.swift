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
    targets: [
        .target(
            name: "TezosSwift",
            path: "TezosSwift",
            exclude: ["Info.plist"]),
    ]
)