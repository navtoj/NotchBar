import AppKit
import LaunchAtLogin
import SFSafeSymbols

final class AppStatus {
	// MARK: Static Properties

	static let shared = AppStatus()

	// MARK: Properties

	private lazy var icon = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	private lazy var menu = NSMenu(title: "NotchBar")

	// MARK: Lifecycle

	private init() {
		// Status Item

		if let button = icon.button {
			#if DEBUG
				let color = NSColor.systemRed
			#else
				let color = NSColor.labelColor
			#endif

			let attributedString = NSAttributedString(
				string: "⏘", // ⌴
				attributes: [
					.font: NSFont.systemFont(ofSize: 22),
					.foregroundColor: color,
					.strokeWidth: -10,
					.strokeColor: color,
				]
			)

			let image = NSImage(
				size: attributedString.size(),
				flipped: false
			) { _ in
				attributedString.draw(at: .init(x: 0, y: 1.5))
				return true
			}

			#if !DEBUG
				image.isTemplate = true
			#endif
			button.image = image
		}

		// Status Menu

		icon.menu = setup(ns: menu)
	}

	// MARK: Functions

	private func setup(ns menu: NSMenu) -> NSMenu {
		let about = NSMenuItem(
			title: "About",
			action: #selector(openAbout),
			keyEquivalent: ""
		)
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			#if DEBUG
				let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
				about.badge = NSMenuItemBadge(string: "\(version).\(build)")
			#else
				about.badge = NSMenuItemBadge(string: version)
			#endif
		}
		about.target = self
		menu.addItem(about)

		let settings = NSMenuItem(
			title: "Settings...",
			action: #selector(AppWindow.shared.open),
			keyEquivalent: ","
		)
		settings.target = AppWindow.shared
		menu.addItem(settings)

		menu.addItem(.separator())

		menu.addItem(
			withTitle: "Quit NotchBar",
			action: #selector(NSApp.terminate(_:)),
			keyEquivalent: "q"
		)

		return menu
	}

	@objc
	private func openAbout() {
		if let url = URL(string: "https://github.com/navtoj/NotchBar") {
			NSWorkspace.shared.open(url)
		} else { print("Error: Invalid URL") }
	}
}
