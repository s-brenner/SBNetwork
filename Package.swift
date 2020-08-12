// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SBNetworkMonitor",
    platforms: [.iOS(.v12), .tvOS(.v12), .macOS(.v10_14)],
    products: [
        .library(name: "SBNetworkMonitor", targets: ["SBNetworkMonitor"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SBNetworkMonitor", dependencies: []),
        .testTarget(name: "SBNetworkMonitorTests", dependencies: ["SBNetworkMonitor"]),
    ]
)
