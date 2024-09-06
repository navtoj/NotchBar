//
//  AppDelegate.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa
import SystemInfoKit
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
	
	// Create Window
	
	private lazy var window = NotchWindow()
	
	// Create Status Menu
	
	private lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
	
	// App Delegate Functions
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		print("applicationWillFinishLaunching")
		
		// Prevent Focus
		
		NSApp.setActivationPolicy(.prohibited)
		
		// Ensure Notch Area
		
		if NSScreen.builtIn?.notchFrame == nil {
			QuitWithLog("NotchBar only supports devices with a notch.")
		}
		
		// Configure Status Bar Item
		
		if let button = statusBarItem.button {
			//			button.title = "NotchBar"
			button.image = NSImage(systemSymbol: .sparkle)
		}
		
		// Configure Status Bar Menu
		
		statusBarItem.menu = NSMenu()
		if let statusBarMenu = statusBarItem.menu {
			statusBarMenu.addItem(
				withTitle: "Quit NotchBar",
				action: #selector(NSApplication.terminate(_:)),
				keyEquivalent: "q"
			)
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
