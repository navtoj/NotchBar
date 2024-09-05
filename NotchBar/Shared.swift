//
//  Shared.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-05.
//

import AppKit
import SystemInfoKit

func QuitWithLog(_ message: String, sender: Any? = nil) {
	
	// Log Message
	print(message)
	
	// Quit App
	NSApplication.shared.terminate(sender)
}

class AppState: ObservableObject {
	static let shared = AppState()
	private init() {}
	
	@Published private(set) var isBarCovered: Bool = false
	func showBar() {
		isBarCovered = false
	}
	func hideBar() {
		isBarCovered = true
	}
}

class AppData: ObservableObject {
	static let shared = AppData()
	private init() {}
	
	@Published private(set) var activeApp = NSWorkspace.shared.frontmostApplication
	func updateActiveApp(_ app: NSRunningApplication) {
		activeApp = app
	}
	
	@Published private(set) var systemInfo = SystemInfoBundle()
	func updateSystemInfo(_ info: SystemInfoBundle) {
		systemInfo = info
	}
}
