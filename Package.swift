// swift-tools-version:5.8.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ebm1d",
    products: [
        .library(name: "ebm1dLib", targets: [ "ebm1dLib"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products
        // in packages which this package depends on.
        .target(
            name: "ebm1dLib",
            dependencies: []),
        .testTarget(
            name: "ebm1dLibTests",
            dependencies: ["ebm1dLib"])
    ]
)
