//
//  Window.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa

class Window: NSWindow {
	
	init() {
		// Create Window
		
		super.init(
			contentRect: NSScreen.builtIn!.frame,
			styleMask: [
//				.nonactivatingPanel
			],
			backing: .buffered,
			defer: false
		)
		
		// Configure View
		
		let viewController = ViewController()
		contentView = viewController.view
		contentViewController = viewController
		
		// Configure Window
		
		level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)) - 1)
		collectionBehavior = [
			.canJoinAllSpaces,
			.stationary,
			.fullScreenNone,
			.ignoresCycle
		]
		backgroundColor = .clear
		
		isOpaque = false
		if isOpaque { print("isOpaque", isOpaque) }
		
		hasShadow = false
		if hasShadow { print("hasShadow", hasShadow) }
		
//		ignoresMouseEvents = true
		if !ignoresMouseEvents { print("ignoresMouseEvents", ignoresMouseEvents) }
		
		isMovable = false
		if isMovable { print("isMovable", isMovable) }
		
		// isMovableByWindowBackground = true
		if isMovableByWindowBackground { print("isMovableByWindowBackground", isMovableByWindowBackground) }
		
		// Track Window Position & Size
		
		NotificationCenter.default.addObserver(
			forName: NSWindow.didMoveNotification,
			object: self,
			queue: nil
		) { _ in
			print("didMoveNotification")
			self.EnsureWindowSizePosition(self)
		}
		
		NotificationCenter.default.addObserver(
			forName: NSWindow.didResizeNotification,
			object: self,
			queue: nil
		) { _ in
			print("didResizeNotification")
			self.EnsureWindowSizePosition(self)
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	private func EnsureWindowSizePosition(_ window: NSWindow, _ skipCheck: Bool = false) {
		print("EnsureWindowSizePosition")
		
		// Ensure Internal Display
		
		guard let display = NSScreen.builtIn else {
			return QuitWithLog("Built-in display not found.")
		}
		
		// Ensure Notch Area
		
		guard display.notchFrame != nil else {
			return QuitWithLog("NotchBar only supports devices with a notch.")
		}
		
		// Get Window Values
		
		let x = window.frame.origin.x
		let y = window.frame.origin.y
		let width = window.frame.width
		let height = window.frame.height
		
		// Get Display Values
		
		let origin = display.frame.origin
		let size = display.frame.size
		
		// Check Window Size Change // https://arc.net/l/quote/remcdzmn
		
		if skipCheck || width != size.width || height != size.height {
			print("Reset Window Size")
			window.setContentSize(size)
		}
		
		// Check Window Position Change
		
		if skipCheck || x != origin.x || y != origin.y {
			print("Reset Window Position")
			window.setFrameOrigin(origin)
		}
	}
}
