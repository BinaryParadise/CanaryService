// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "CanaryBackend",
	products: [
		.executable(name: "CanaryBackend", targets: ["CanaryBackend"])
	],
	dependencies: [
		.package(name: "PerfectHTTPServer", url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(name: "PerfectWebSockets", url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        .package(name: "SwiftyJSON", path: "../common/SwiftyJSON"),
        .package(name: "PerfectSQLite", path: "../common/Perfect-SQLite"),
        .package(name: "CanaryProto", path: "../common/CanaryProto"),
        .package(name: "PerfectSession", url:"https://github.com/PerfectlySoft/Perfect-Session.git", from: "3.0.0"),
	],
	targets: [
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
