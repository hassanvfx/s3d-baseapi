// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "S3DBaseAPI",
    platforms: [
           .iOS(.v15), // Set the minimum iOS version to 16
           .macOS(.v10_15)
       ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "S3DBaseAPI",
            targets: ["S3DBaseAPI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url:"git@github.com:hassanvfx/s3d-coremodels.git", .upToNextMajor(from: "0.0.1")),
        .package(url:"https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "S3DBaseAPI",
            dependencies: [
                .product(name: "S3DCoreModels", package: "s3d-coremodels"),
                .product(name: "Moya", package: "Moya"),
                .product(name: "CombineMoya", package: "Moya"),
            ]),
        .testTarget(
            name: "S3DBaseAPITests",
            dependencies: ["S3DBaseAPI"]),
    ]
)
