//
//  AppDelegate.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-27.
//

import AppKit
import SFSafeSymbols

final class AppDelegate: NSObject, NSApplicationDelegate {

	// create window

	private lazy var window = AppWindow.shared

	// create status item

	private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

	// app functions

	func applicationWillFinishLaunching(_ notification: Notification) {
		print("applicationWillFinishLaunching")

		// prevent focus

		NSApp.setActivationPolicy(.prohibited)

		// configure status item

		if let button = statusItem.button {

			// set item icon

			button.image = NSImage(systemSymbol: .sparkle)

			// set item action

			button.action = #selector(toggleSettings)
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

	// helper actions

	@objc private func toggleSettings() {
		AppState.shared.toggleSettings()
	}
}
