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
	
	// Create System Info Observer
	
	let observer = SystemInfoObserver.shared(monitorInterval: 1.0)
	var cancellables = Set<AnyCancellable>()
	
	// Create Window
	
	private lazy var window = NotchWindow()
	
	// App Delegate Functions
	
	func applicationWillFinishLaunching(_ notification: Notification) {
//		print("applicationWillFinishLaunching")
		
		// Prevent Focus
		
		NSApp.setActivationPolicy(.prohibited)
		
		// Ensure Notch Area
		
		guard NSScreen.builtIn?.notchFrame != nil else {
			return QuitWithLog("NotchBar only supports devices with a notch.")
		}
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
//		print("applicationDidFinishLaunching")
		
		// Show Window
		
		window.orderFrontRegardless()
		
		// Track Active App
		
		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(UpdateActiveApp),
			name: NSWorkspace.didActivateApplicationNotification,
			object: nil
		)
		
		// Track System Info
		
		observer.systemInfoPublisher
			.sink { systemInfo in
				self.UpdateSystemInfo(systemInfo)
			}
			.store(in: &cancellables)
		
		observer.startMonitoring()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		print("applicationWillTerminate")
		
		// Stop System Info Observer
	
		observer.stopMonitoring()
	}
	
	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return false
	}
	
	@objc private func UpdateActiveApp(_ notification: Notification) {
		
		// Get NSRunningApplication
		
		guard let userInfo = notification.userInfo else {
			return QuitWithLog("Failed to get userInfo.")
		}
		
		guard let app = userInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
			return QuitWithLog("Failed to get NSRunningApplication.")
		}
		
//		print("UpdateActiveApp", app.bundleIdentifier ?? "Unknown")
		
		AppData.shared.updateActiveApp(app)
	}
	
	private func UpdateSystemInfo(_ systemInfo: SystemInfoBundle) {
		
//		print("UpdateSystemInfo", systemInfo.description)
		
		AppData.shared.updateSystemInfo(systemInfo)
	}
}
