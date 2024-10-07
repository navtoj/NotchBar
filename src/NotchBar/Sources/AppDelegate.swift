import AppKit
import SFSafeSymbols
import LaunchAtLogin

final class AppDelegate: NSObject, NSApplicationDelegate {

	// create singleton instance

	static let shared = AppDelegate()

	// create window

	private lazy var window = AppWindow.shared

	// create status item

	private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

	// create status menu

	private lazy var statusItemMenu = NSMenu()

	// create status menu items

	private lazy var launchAtLogin = NSMenuItem(
		title: "Launch at Login",
		action: #selector(toggleLaunchAtLogin),
		keyEquivalent: "l"
	)

	// app functions

	func applicationWillFinishLaunching(_ notification: Notification) {
#if DEBUG
		print("applicationWillFinishLaunching")
#endif

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

#if DEBUG
		statusItemMenu.addItem(
			withTitle: "Debug Mode",
			action: nil,
			keyEquivalent: ""
		)
		statusItemMenu.items.first?.isEnabled = false

		statusItemMenu.addItem(.separator())
#endif

		statusItemMenu.addItem(launchAtLogin)
		launchAtLogin.state = LaunchAtLogin.isEnabled ? .on : .off

		statusItemMenu.addItem(.separator())

		statusItemMenu.addItem(
			withTitle: "Quit NotchBar",
			action: #selector(NSApp.terminate(_:)),
			keyEquivalent: "q"
		)
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
#if DEBUG
		print("applicationDidFinishLaunching")
#endif

		// show window

		window.orderFrontRegardless()
	}

	func applicationWillTerminate(_ notification: Notification) {
#if DEBUG
		print("applicationWillTerminate")
#endif
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { false }

	// helper actions

	@objc func handleClick() {

		// get current event

		guard let event = NSApp.currentEvent else {
			return print("Status Menu Click Event Not Found.")
		}

		// handle left click

		guard event.type != NSEvent.EventType.leftMouseUp else {
			return AppState.shared.toggleSettings()
		}

		// handle right click

		statusItem.menu = statusItemMenu

		statusItem.button?.performClick(nil)

		statusItem.menu = nil
	}

	@objc private func toggleLaunchAtLogin() {
		LaunchAtLogin.isEnabled.toggle()
		launchAtLogin.state = LaunchAtLogin.isEnabled ? .on : .off
	}
}
