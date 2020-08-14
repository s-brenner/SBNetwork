// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SBNetwork",
    platforms: [.iOS(.v12), .tvOS(.v12), .macOS(.v10_14)],
    products: [
        .library(name: "SBNetwork", targets: ["SBNetwork"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SBNetwork", dependencies: []),
        .testTarget(name: "SBNetworkTests", dependencies: ["SBNetwork"]),
    ]
)
