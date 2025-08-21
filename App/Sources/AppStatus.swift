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
			let unicode = "⏘" // ⌴
			#if DEBUG
				let color = NSColor.systemRed
			#else
				let color = NSColor.labelColor
			#endif

			let font = NSFont.systemFont(ofSize: 22)
			let attributes: [NSAttributedString.Key: Any] = [
				.font: font,
				.strokeWidth: -10,
				.foregroundColor: color,
				.strokeColor: color,
			]

			let attributedString = NSAttributedString(string: unicode, attributes: attributes)
			let size = attributedString.size()
			let image = NSImage(size: size)

			image.lockFocus()
			attributedString.draw(at: .init(x: -0.5, y: 1.5))
			image.unlockFocus()

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
