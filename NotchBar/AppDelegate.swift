//
//  AppDelegate.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa
import SystemInfoKit
import Combine
import LaunchAtLogin

final class AppDelegate: NSObject, NSApplicationDelegate {
	
	// Create Window
	
	private lazy var window = NotchWindow.shared
	
	// Create Status Item
	
	private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	// Create Status Menu Items
	
	private lazy var launchAtLogin = NSMenuItem(
		title: "Launch at Login",
		action: #selector(toggleLaunchAtLogin),
		keyEquivalent: "l"
	)
	
	// App Delegate Functions
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		print("applicationWillFinishLaunching")
		
		// Prevent Focus
		
		NSApp.setActivationPolicy(.prohibited)
		
		// Ensure Notch Area
		
		if NSScreen.builtIn?.notchFrame == nil {
			QuitWithLog("NotchBar only supports devices with a notch.")
		}
		
		// Configure Status Item
		
		if let button = statusItem.button {
			button.image = NSImage(systemSymbol: .sparkle)
		}
		
		// Create Status Item Menu
		
		statusItem.menu = NSMenu()
		if let menu = statusItem.menu {
			
			// Add Launch at Login Item
			
			updateLaunchAtLoginIcon()
			menu.addItem(launchAtLogin)
			
			// Add Separator
			
			menu.addItem(.separator())
			
			// Add Quit Item
			
			menu.addItem(
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
	
	// Status Menu Functions
	
	@objc private func toggleLaunchAtLogin() {
		LaunchAtLogin.isEnabled.toggle()
		updateLaunchAtLoginIcon()
	}
	
	private func updateLaunchAtLoginIcon() {
		launchAtLogin.image = LaunchAtLogin.isEnabled ? NSImage(systemSymbol: .checkmarkCircleFill) : nil
	}
}
