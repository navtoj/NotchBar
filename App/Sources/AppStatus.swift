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

		icon.menu = menu

		let autoStart = NSMenuItem(
			title: "Open at Login",
			action: #selector(toggleAutoStart),
			keyEquivalent: "l"
		)
		autoStart.state = LaunchAtLogin.isEnabled ? .on : .off
		autoStart.target = self
		menu.addItem(autoStart)

		menu.addItem(.separator())

		menu.addItem(
			withTitle: "Quit NotchBar",
			action: #selector(NSApp.terminate(_:)),
			keyEquivalent: "q"
		)
	}

	// MARK: Functions

	@objc
	private func toggleAutoStart(_ sender: NSMenuItem) {
		let isEnabled = sender.state == .on
		sender.state = isEnabled ? .off : .on
		LaunchAtLogin.isEnabled = !isEnabled
	}
}
