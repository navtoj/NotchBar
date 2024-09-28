//
//  AppDelegate.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-27.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

	// create window

	private lazy var window = AppWindow.shared

	// create status item

	private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

	// app functions

	func applicationWillFinishLaunching(_ notification: Notification) {
		print("applicationWillFinishLaunching")

		// prevent focus

//		NSApp.setActivationPolicy(.prohibited)
		// FIXME: hides app during launch

		// configure status item

		if let button = statusItem.button {
			button.image = NSImage(systemSymbolName: "sparkle", accessibilityDescription: nil)
		}
		// TODO: add SFSafeSymbols package

		// create status item menu

		statusItem.menu = NSMenu()
		if let menu = statusItem.menu {

#if DEBUG
			// add debug item

			let quitItem = NSMenuItem(title: "Debug Mode", action: nil, keyEquivalent: "")
			quitItem.isEnabled = false
			menu.addItem(quitItem)

			// add separator

			menu.addItem(.separator())
#endif

			// TODO: add LaunchAtLogin package

			// add quit item

			menu.addItem(
				withTitle: "Quit NotchBar",
				action: #selector(NSApplication.shared.terminate(_:)),
				keyEquivalent: "q"
			)
		}
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		print("applicationDidFinishLaunching")

		// show window

		window.orderFrontRegardless()
	}

	func applicationWillTerminate(_ notification: Notification) {
		print("applicationWillTerminate")
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { false }
}
