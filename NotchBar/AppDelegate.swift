//
//  AppDelegate.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa

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

class AppDelegate: NSObject, NSApplicationDelegate {
	
	// Create Window
	
	private lazy var window = NotchWindow()
	
	// App Delegate Functions
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		print("applicationWillFinishLaunching")
		
		// Prevent Focus
		
		NSApp.setActivationPolicy(.prohibited)
		
		// Ensure Notch Area
		
		guard NSScreen.builtIn?.notchFrame != nil else {
			return QuitWithLog("NotchBar only supports devices with a notch.")
		}
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		print("applicationDidFinishLaunching")
		
		// Show Window
		
		window.orderFrontRegardless()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		print("applicationWillTerminate")
	}
	
	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return false
	}
}
