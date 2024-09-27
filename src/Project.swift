import ProjectDescription

let project = Project(
	name: "NotchBar",
	targets: [
		.target(
			name: "NotchBar",
			destinations: .macOS,
			product: .app,
			bundleId: "io.tuist.NotchBar",
			infoPlist: .default,
			sources: ["NotchBar/Sources/**"],
			resources: ["NotchBar/Resources/**"],
			dependencies: []
		),
		.target(
			name: "NotchBarTests",
			destinations: .macOS,
			product: .unitTests,
			bundleId: "io.tuist.NotchBarTests",
			infoPlist: .default,
			sources: ["NotchBar/Tests/**"],
			resources: [],
			dependencies: [.target(name: "NotchBar")]
		),
	]
)
