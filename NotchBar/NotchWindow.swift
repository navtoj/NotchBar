//
//  NotchWindow.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa
import SwiftUI

final class NotchWindow: NSWindow {
	private let debug = false
	static let shared = NotchWindow()
	
	private var observers: [NSObjectProtocol] = []
	
	private init() {
		super.init(
			contentRect: NSScreen.builtIn!.frame,
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		EnsureWindowSizePosition(self)
		
		// Configure View
		
		contentView = NSHostingView(rootView: ContentView())
		
		// Configure Window
		
		level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.normalWindow)) + 1)
		collectionBehavior = [
			.canJoinAllSpaces,
			.stationary,
			.fullScreenNone,
			.ignoresCycle
		]
		backgroundColor = .clear
		
		isOpaque = false
		if debug && isOpaque { print("isOpaque", isOpaque) }
		
		hasShadow = false
		if debug && hasShadow { print("hasShadow", hasShadow) }
		
//		ignoresMouseEvents = true
		if debug && ignoresMouseEvents { print("ignoresMouseEvents", ignoresMouseEvents) }
		
		isMovable = false
		if debug && isMovable { print("isMovable", isMovable) }
		
//		isMovableByWindowBackground = true
		if debug && isMovableByWindowBackground { print("isMovableByWindowBackground", isMovableByWindowBackground) }
		
		// Track Window Position & Size
		
		observers.append(NotificationCenter.default.addObserver(
			forName: NSWindow.didMoveNotification,
			object: nil,
			queue: nil
		) { notification in
			if self.debug { print("didMoveNotification", notification.name.rawValue) }
			self.EnsureWindowSizePosition(self)
		})
		
		observers.append(NotificationCenter.default.addObserver(
			forName: NSWindow.didResizeNotification,
			object: nil,
			queue: nil
		) { notification in
			if self.debug { print("didResizeNotification", notification.name.rawValue) }
			self.EnsureWindowSizePosition(self)
		})
		
		observers.append(NotificationCenter.default.addObserver(
			forName: NSApplication.didChangeScreenParametersNotification,
			object: nil,
			queue: nil
		) { notification in
			if self.debug { print("didChangeScreenParametersNotification", notification.name.rawValue) }
		})
	}
	
	deinit {
		for observer in observers {
			NotificationCenter.default.removeObserver(observer)
		}
		observers.removeAll()
	}
	
	private func EnsureWindowSizePosition(_ window: NSWindow, _ skipCheck: Bool = false) {
		if debug { print("EnsureWindowSizePosition") }
		
		// Ensure Internal Display
		
		guard let display = NSScreen.builtIn else {
			return QuitWithLog("Built-in display not found.")
		}
		
		// Ensure Notch Area
		
		guard let notch = display.notchFrame else {
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
			if debug { print("Reset Window Size") }
			window.setContentSize(size)
		}
		
		// Check Window Position Change
		
		if (skipCheck || x != origin.x || y != origin.y) {
			if debug { print("Reset Window Position") }
			window.setFrameOrigin(origin)
		}
		
		// Check Menu Bar Visibility
		
		let isMenuBarVisible = display.frame.height != (display.visibleFrame.height + notch.height)
		if debug { print("isMenuBarVisible", isMenuBarVisible) }
		window.alphaValue = isMenuBarVisible ? 0 : 1
	}
}
