// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "heic",
        products: [
            .executable(name: "heic", targets: ["heic"])
        ],
        dependencies: [
            // Dependencies declare other packages that this package depends on.
            .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
            .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages this package depends on.
            .executableTarget(
                    name: "heic",
                    dependencies: [
                        .product(name: "ArgumentParser", package: "swift-argument-parser"),
                        .product(name: "Rainbow", package: "Rainbow"),
                    ]),
            .testTarget(
                    name: "heicTests",
                    dependencies: ["heic"]),
        ]
)
