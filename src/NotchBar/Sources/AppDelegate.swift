import AppKit
import SFSafeSymbols
import LaunchAtLogin
import Defaults

extension Defaults.Keys {
	static let skipWelcome = Key<Bool>("skipWelcome", default: false)
}

final class AppDelegate: NSObject, NSApplicationDelegate {

	// create singleton instance

	static let shared = AppDelegate()

	// create window

	private lazy var window = AppWindow.shared

	// create status item

	private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

	// create status menu

	private lazy var statusItemMenu = NSMenu()

	// app functions

	func applicationWillFinishLaunching(_ notification: Notification) {

		// prevent focus

		NSApp.setActivationPolicy(.prohibited)

		// configure status item

		if let button = statusItem.button {

			// set item icon

			button.image = NSImage(systemSymbol: .sparkle)

			// set item action

			button.action = #selector(handleClick)
			button.target = self
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
		}

		// configure status menu

		statusItemMenu.addItem(
			withTitle: "Check for Updates...",
			action: #selector(openGithub),
			keyEquivalent: "u"
		)

		statusItemMenu.addItem(.separator())

		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
		   let bundle = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
			statusItemMenu.addItem(
				withTitle: version + "." + bundle,
//				action: #selector(NSApp.orderFrontStandardAboutPanel(_:)),
				action: nil,
				keyEquivalent: ""
			)
		}

		statusItemMenu.addItem(
			withTitle: "Quit NotchBar",
			action: #selector(NSApp.terminate(_:)),
			keyEquivalent: "q"
		)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {

		// show window

		window.orderFrontRegardless()
	}

	func applicationWillTerminate(_ notification: Notification) {}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { false }

	// helper actions

	@objc func handleClick() {

		// get current event

		guard let event = NSApp.currentEvent else {
			return print("Status Menu Event Not Found.")
		}

		// handle event

		switch event.type {
			case .leftMouseUp:
				AppState.shared.toggleCard(.settings)

			case .rightMouseUp:
				statusItem.menu = statusItemMenu
				statusItem.button?.performClick(nil)
				statusItem.menu = nil

			default:
				print("> Invalid Event Type")
		}
	}

	@objc func openGithub() {
		if let url = URL(string: "https://github.com/navtoj/NotchBar/releases") {
			NSWorkspace.shared.open(url)
		} else { print("Error: Invalid GitHub URL") }
	}
}
