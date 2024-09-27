import ProjectDescription

let project = Project(
	name: "NotchBar",
	targets: [
		.target(
			name: "NotchBar",
			destinations: .macOS,
			product: .app,
			bundleId: "com.navtoj.NotchBar",
			deploymentTargets: .macOS("14.6.1"),
			infoPlist: .default,
			sources: ["NotchBar/Sources/**"],
			resources: ["NotchBar/Resources/**"],
			dependencies: []
		),
		.target(
			name: "NotchBarTests",
			destinations: .macOS,
			product: .unitTests,
			bundleId: "com.navtoj.NotchBarTests",
			deploymentTargets: .macOS("14.6.1"),
			infoPlist: .default,
			sources: ["NotchBar/Tests/**"],
			resources: [],
			dependencies: [.target(name: "NotchBar")]
		),
	]
)
