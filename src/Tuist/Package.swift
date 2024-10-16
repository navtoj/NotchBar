// swift-tools-version: 5.9
@preconcurrency
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
	// Customize the product types for specific package product
	// Default is .staticFramework
	// productTypes: ["Alamofire": .framework,]
	productTypes: [:]
)
#endif

let package = Package(
	name: "NotchBar",
	dependencies: [
		// https://docs.tuist.io/documentation/tuist/dependencies
		.package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", .upToNextMajor(from: "5.3.0")),
		.package(url: "https://github.com/sindresorhus/LaunchAtLogin-Modern", .upToNextMajor(from: "1.1.0")),
		.package(url: "https://github.com/EmergeTools/Pow", .upToNextMajor(from: "1.0.4")),
		.package(url: "https://github.com/Kyome22/SystemInfoKit", .upToNextMajor(from: "3.2.0")),
		.package(url: "https://github.com/sindresorhus/Defaults", .upToNextMajor(from: "8.2.0")),
	]
)
