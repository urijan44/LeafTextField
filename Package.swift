// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeafTextField",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LeafTextField",
            targets: ["LeafTextField"]),
    ],
    targets: [
      .target(
        name: "LeafTextField",
        path: "LeafTextField/Classes")
    ],
    swiftLanguageVersions: [
        .v5
    ]

)

