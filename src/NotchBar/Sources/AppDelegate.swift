import AppKit
import Defaults
import SwiftUICore
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

	// app functions

	func applicationWillFinishLaunching(_ notification: Notification) {

		// prevent focus

		NSApp.setActivationPolicy(.prohibited)

		// configure status item

		if let button = statusItem.button {

			// set item icon

#if DEBUG
			button.image = NSImage(systemSymbol: .sparkles)
#else
			button.image = NSImage(systemSymbol: .sparkle)
#endif

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

	// To-Do URL Scheme

	func application(_ application: NSApplication, open urls: [URL]) {
		for url in urls {

			// Process URL

//			guard let scheme = url.scheme else { return print("Invalid URL scheme.") }
//			print("scheme :", scheme) // notchbar

			guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
				  let path = components.path,
				  let params = components.queryItems else {
				return print("Invalid URL path or params missing.")
			}
//			print("path :", path) // todo
//			print("params :", params) // set=a todo item

			// Validate Path

			guard path == "todo" else { return print("Unknown URL Path:", path) }

			// Process Params

			for param in params {
				guard let key = param.name as String?,
					  let value = param.value as String? else {
					return print("Invalid URL Param:", param)
				}
//				print("key :", key) // set
//				print("value :", value) // a todo item

				// Handle Params

				switch key {
					case "set":
						Defaults[.todoWidget] = value
					default:
						print("Unknown URL Param:", key)
				}
			}
		}
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
