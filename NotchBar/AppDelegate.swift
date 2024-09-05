//
//  AppDelegate.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
	
	// Create Window
	
	private lazy var window = Window()
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		
		// Ensure Notch Area
		
		guard NSScreen.builtIn?.notchFrame != nil else {
			return QuitWithLog("NotchBar only supports devices with a notch.")
		}
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// Show Window
		
		window.orderFrontRegardless()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return false
	}
}
