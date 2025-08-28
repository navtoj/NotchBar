import AppKit
import LaunchAtLogin
import SFSafeSymbols

// MARK: - AppStatus

final class AppStatus {
	// MARK: Static Properties

	static let shared = AppStatus()

	// MARK: Properties

	private lazy var icon = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	private lazy var menu = NSMenu(title: "NotchBar")

	private lazy var info = NSMenuItem()
	private lazy var infoSeparator = NSMenuItem.separator()

	// MARK: Lifecycle

	private init() {
		// Status Item

		if let button = icon.button {
			button.image = iconImage()
		}

		// Status Menu

		icon.menu = setup(ns: menu)
	}

	// MARK: Functions

	/// Show or hide the info section.
	func update(_ status: Status?) {
		if let status {
			info.title = "Status"
			info.subtitle = status.rawValue

			info.isHidden = false
			infoSeparator.isHidden = false

			if let button = icon.button {
				button.appearsDisabled = true
			}
		} else {
			info.isHidden = true
			infoSeparator.isHidden = true

			if let button = icon.button {
				button.appearsDisabled = false
			}
		}
	}
}

// MARK: - Helpers

private extension AppStatus {
	func iconImage(color override: NSColor? = nil) -> NSImage? {
		let color = override ?? .controlTextColor

		let glyph = NSAttributedString(
			string: "⏘", // ⌴
			attributes: [
				.font: NSFont.systemFont(ofSize: 22),
				.foregroundColor: color,
				.strokeWidth: -10,
				.strokeColor: color,
			]
		)

		let image = NSImage(
			size: glyph.size(),
			flipped: false
		) { _ in
			glyph.draw(at: .init(x: 0, y: 2))
			return true
		}

		if override == nil {
			image.isTemplate = true
		}

		return image
	}

	func setup(ns menu: NSMenu) -> NSMenu {
		info.isHidden = true
		infoSeparator.isHidden = true
		menu.addItem(info)
		menu.addItem(infoSeparator)

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
			action: #selector(SettingsWindow.shared.open),
			keyEquivalent: ","
		)
		settings.target = SettingsWindow.shared
		menu.addItem(settings)

		menu.addItem(.separator())

		menu.addItem(
			withTitle: "Quit NotchBar",
			action: #selector(NSApp.terminate),
			keyEquivalent: "q"
		)

		return menu
	}

	@objc
	func openAbout() {
		if let url = URL(string: "https://github.com/navtoj/NotchBar") {
			NSWorkspace.shared.open(url)
		} else { print("Error: Invalid URL") }
	}
}
