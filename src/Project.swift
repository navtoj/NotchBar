import ProjectDescription

let project = Project(
	name: "NotchBar",
	settings: .settings(base: [
		"ENABLE_USER_SCRIPT_SANDBOXING": .init(booleanLiteral: true),
		"ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": .init(booleanLiteral: true),
	]),
	targets: [
		.target(
			name: "NotchBar",
			destinations: .macOS,
			product: .app,
			bundleId: "com.navtoj.notchbar",
			deploymentTargets: .macOS("14.6.1"),
			infoPlist: .extendingDefault(with: [
				"LSUIElement": true,
				"LSApplicationCategoryType": "public.app-category.productivity",
				"CFBundleShortVersionString": "0.0.3", // Public
				"CFBundleVersion": "2", // Internal
				"CFBundleURLTypes": .array([
					.dictionary([
						"CFBundleURLName": .string("com.navtoj.notchbar"),
						"CFBundleURLSchemes": .array(["notchbar"]),
						"CFBundleTypeRole": .string("Viewer"),
					]),
				]),
			]),
			sources: ["NotchBar/Sources/**"],
			resources: ["NotchBar/Resources/**"],
			dependencies: [
				.external(name: "SFSafeSymbols"),
				.external(name: "LaunchAtLogin"),
				.external(name: "Pow"),
				.external(name: "SystemInfoKit"),
				.external(name: "Defaults"),
			]
		),
	]
)
