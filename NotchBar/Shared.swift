//
//  Shared.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-05.
//

import AppKit
import SystemInfoKit
import Combine

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
	
	@Published private(set) var activeApp = NSWorkspace.shared.frontmostApplication
	@Published private(set) var systemInfo = SystemInfoBundle()
	
	// Create System Info Observer
	
	private let observer = SystemInfoObserver.shared(monitorInterval: 1.0)
	private var cancellables = Set<AnyCancellable>()
	
	private init() {
		// Track Active App
		
		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(handleDidActivateApplicationNotification),
			name: NSWorkspace.didActivateApplicationNotification,
			object: nil
		)
		
		// Track System Info
		
		observer.systemInfoPublisher
			.sink { systemInfo in
				self.systemInfo = systemInfo
			}
			.store(in: &cancellables)
		
		observer.startMonitoring()
	}
	
	deinit {
		// Remove Active App Observer
		
		NSWorkspace.shared.notificationCenter.removeObserver(self)
		
		// Stop System Info Observer
		
		observer.stopMonitoring()
	}
	
	@objc private func handleDidActivateApplicationNotification(_ notification: Notification) {
		print("didActivateApplicationNotification")
		
		guard let userInfo = notification.userInfo else {
			return print("Failed to get active app notification.")
		}
		
		guard let app = userInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
			return print("Failed to get NSRunningApplication.")
		}
		
		self.activeApp = app
	}
}
