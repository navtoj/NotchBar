import AppKit
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
			let image = NSImage(systemSymbol: .space)
			button.image = image
		}

		// Status Menu

		icon.menu = menu

		menu.addItem(
			withTitle: "Quit NotchBar",
			action: #selector(NSApp.terminate(_:)),
			keyEquivalent: "q"
		)
	}
}
