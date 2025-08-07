import ProjectDescription

let project = Project(
	name: "Placeholder",
	settings: .settings(base: [
		"ENABLE_USER_SCRIPT_SANDBOXING": true,
		"ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": true,
		"ENABLE_MODULE_VERIFIER": true,
	]),
	targets: [
		.target(
			name: "Placeholder",
			destinations: .macOS,
			product: .app,
			bundleId: "dev.tuist.Placeholder",
			deploymentTargets: .macOS("14.7.6"),
			infoPlist: .extendingDefault(with: [
				"CFBundleVersion": "1", // Internal
				"CFBundleShortVersionString": "0.0.1", // Public
				"LSApplicationCategoryType": "public.app-category.productivity",
			]),
			sources: ["App/Sources/**"],
			resources: ["App/Resources/**"],
			entitlements: .dictionary([
				"com.apple.security.app-sandbox": true,
				"com.apple.security.files.user-selected.read-only": true,
			]),
			dependencies: [],
			settings: .settings(base: [
				"CODE_SIGN_STYLE": "Automatic", // Manual
				"CODE_SIGN_IDENTITY": "Apple Development", // Mac Developer
				"DEVELOPMENT_TEAM": "FUG9F8QSPW", // grep -r DEVELOPMENT_TEAM *
				"ENABLE_HARDENED_RUNTIME": true,
			]),
			environmentVariables: [
				"IDEPreferLogStreaming": .environmentVariable(value: "YES", isEnabled: true),
			]
		),
	]
)
