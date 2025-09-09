import ProjectDescription

let name = "NotchBar"
let bundleId = "com.navtoj.\(name)"

let project = Project(
	name: name,
	settings: .settings(base: [
		"ENABLE_USER_SCRIPT_SANDBOXING": true,
		"ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true,
		"ENABLE_MODULE_VERIFIER": true,
	]),
	targets: [
		.target(
			name: name,
			destinations: .macOS,
			product: .app,
			bundleId: bundleId,
			deploymentTargets: .macOS("15.6.1"),
			infoPlist: .extendingDefault(with: [
				"CFBundleVersion": "1", // Internal
				"CFBundleShortVersionString": "0.0.1", // Public
				"LSApplicationCategoryType": "public.app-category.productivity",
				"NSHumanReadableCopyright": "Copyright © Navtoj Chahal",
				"LSUIElement": true,
				"NSMainStoryboardFile": "",
				"NSAppleEventsUsageDescription": "Permission to toggle the menu bar.",
				"NSAccessibilityUsageDescription": "Permission to toggle the menu bar?",
			]),
			sources: ["App/Sources/**"],
			resources: [
				.glob(
					pattern: "App/Resources/**",
					excluding: [.path("App/Resources/Public/**")]
				),
				.folderReference(path: "App/Resources/Public"),
			],
			entitlements: .dictionary([
				//				"com.apple.security.app-sandbox": true,
//				"com.apple.security.files.user-selected.read-only": true,
				"com.apple.security.automation.apple-events": true,
				"com.apple.security.scripting-targets": [
					"com.apple.systemevents": ["*"],
				],
				"com.apple.security.accessibility": true,
			]),
			dependencies: [
				.external(name: "SFSafeSymbols"),
				.external(name: "LaunchAtLogin"),
				.external(name: "Defaults"),
				.external(name: "AXSwift"),
			],
			settings: .settings(
				base: [
					"CODE_SIGN_STYLE": "Automatic", // Manual
					"CODE_SIGN_IDENTITY": "Apple Development", // Mac Developer
					"DEVELOPMENT_TEAM": "FUG9F8QSPW", // grep -r DEVELOPMENT_TEAM *
					"ENABLE_HARDENED_RUNTIME": true,
				],
				debug: [
					"PRODUCT_BUNDLE_IDENTIFIER": "\(bundleId).debug",
				]
			),
			environmentVariables: [
				"IDEPreferLogStreaming": .environmentVariable(value: "YES", isEnabled: true),
			]
		),
	]
)
