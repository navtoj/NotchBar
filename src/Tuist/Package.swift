// swift-tools-version: 5.9
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
		// Add your own dependencies here:
		// .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
		// You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
		.package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", .upToNextMajor(from: "5.3.0")),
		.package(url: "https://github.com/sindresorhus/LaunchAtLogin-Modern", .upToNextMajor(from: "1.1.0")),
		.package(url: "https://github.com/EmergeTools/Pow", .upToNextMajor(from: "1.0.4")),
	]
)
