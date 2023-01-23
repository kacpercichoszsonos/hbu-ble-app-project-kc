// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Symphony",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Symphony",
            targets: ["Symphony"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Badge",
//            targets: ["Badge"]),
//        .library(
//            name: "Banner",
//            targets: ["Banner"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
//        .library(
//            name: "Avatar",
//            targets: ["Avatar"]),
        
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/yannickl/DynamicColor.git", from: "5.0.1"),
         .package(url: "https://github.com/kean/Nuke.git", from: "11.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Symphony",
            dependencies: ["DynamicColor", .product(name: "NukeUI", package: "Nuke")]),
        .testTarget(
            name: "SymphonyTests",
            dependencies: ["Symphony"]),
//        .target(
//            name: "Avatar",
//            dependencies: []),
//        .target(
//            name: "Badge",
//            dependencies: []),
//        .target(
//            name: "Banner",
//            dependencies: []),
//        .target(
//            name: "CustomeImage",
//            dependencies: []),
//        .target(
//            name: "CustomToggle",
//            dependencies: []),
//        .target(
//            name: "FeedHeader",
//            dependencies: []),
//        .target(
//            name: "GridItem",
//            dependencies: []),
//        .target(
//            name: "Handle",
//            dependencies: []),
//        .target(
//            name: "Header",
//            dependencies: []),
//        .target(
//            name: "Icon",
//            dependencies: []),
//        .target(
//            name: "ListItem",
//            dependencies: []),
//        .target(
//            name: "ProgressBarCircular",
//            dependencies: []),
//        .target(
//            name: "ScrollViewOffset",
//            dependencies: []),
//        .target(
//            name: "SearchBar",
//            dependencies: []),
//        .target(
//            name: "SectionHeader",
//            dependencies: []),
//        .target(
//            name: "StyleSheet",
//            dependencies: []),
    ]
)
