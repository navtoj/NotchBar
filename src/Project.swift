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
			bundleId: "com.navtoj.NotchBar",
			deploymentTargets: .macOS("14.6.1"),
			infoPlist: .extendingDefault(with: [
				"LSUIElement": true,
				"LSApplicationCategoryType": "public.app-category.productivity",
				"CFBundleShortVersionString": "0.0.2", // Public
				"CFBundleVersion": "0", // Internal
			]),
			sources: ["NotchBar/Sources/**"],
			resources: ["NotchBar/Resources/**"],
			dependencies: [
				.external(name: "SFSafeSymbols"),
				.external(name: "LaunchAtLogin"),
				.external(name: "Pow"),
				.external(name: "SystemInfoKit"),
			]
		),
	]
)
