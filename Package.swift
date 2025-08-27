// swift-tools-version: 6.0
import PackageDescription

#if TUIST
	import struct ProjectDescription.PackageSettings

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
		// Add your own dependencies here:
		// .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
		// You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
		.package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "6.2.0")),
		.package(url: "https://github.com/sindresorhus/LaunchAtLogin-Modern", .upToNextMajor(from: "1.1.0")),
		.package(url: "https://github.com/sindresorhus/Defaults", .upToNextMajor(from: "9.0.3")),
	]
)
