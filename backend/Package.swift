// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "CanaryCore",
    platforms: [.macOS(.v10_15)],
	products: [
        .executable(name: "Run", targets: ["Run"]),
	],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        //.package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMinor(from: "5.0.0")),
        .package(name: "SwiftyJSON", path: "../common/SwiftyJSON"),
        .package(name: "PerfectSQLite", path: "../common/Perfect-SQLite"),
        .package(url: "https://github.com/BinaryParadise/Canary.git", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "4.52.0")),
    ], targets: [
        .target(name: "Run", dependencies: ["App"]),
        .target(
            name: "App",
            dependencies: [
                "Rainbow",
                "SwiftyJSON",
                .product(name: "Proto", package: "Canary"),
                "PerfectSQLite",
                .product(name: "Vapor", package: "vapor"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
	]
)
