// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "CanaryBackend",
	products: [
		.executable(name: "CanaryBackend", targets: ["CanaryBackend"])
	],
    dependencies: [
        .package(name: "PerfectHTTPServer", url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", .upToNextMinor(from: "3.0.0")),
        .package(name: "PerfectWebSockets", url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git", .upToNextMinor(from: "3.1.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMinor(from: "5.0.0")),
        .package(name: "PerfectSQLite", path: "../common/Perfect-SQLite"),
        .package(name: "CanaryProto", path: "../common/CanaryProto"),
        .package(name: "PerfectSession", url:"https://github.com/PerfectlySoft/Perfect-Session.git", .upToNextMinor(from: "3.1.0")),
    ], targets: [
        .target(
            name: "CanaryBackend",
            dependencies: [
				"PerfectHTTPServer",
				"PerfectWebSockets",
                "Rainbow",
                "SwiftyJSON",
                "CanaryProto",
                "PerfectSQLite",
                "PerfectSession",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
			]
        ),
	]
)
