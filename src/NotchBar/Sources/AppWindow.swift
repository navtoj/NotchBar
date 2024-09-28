//
//  AppWindow.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-27.
//

import SwiftUI

final class AppWindow: NSWindow {

	// create singleton instance

	static let shared = AppWindow()

	// hold observers for deinit

	private var notificationObservers: [NSObjectProtocol] = []
	private var userDefaultsObservers: [NSKeyValueObservation] = []

	// disallow direct instantiation

	private init() {

		// make sure built-in screen is available

		guard let screen = NSScreen.builtIn else {

			// quit application

			fatalError("Built-in screen not found.")
		}

		// create window

		super.init(
			contentRect: screen.frame,
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		print("window", frame)

		// configure window

		level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.normalWindow)) + 1)
		collectionBehavior = [
			.canJoinAllSpaces,
			.stationary,
			.fullScreenNone,
			.ignoresCycle
		]
		backgroundColor = .clear
		isOpaque = false
		hasShadow = false
//		ignoresMouseEvents = true
		isMovable = false
//		isMovableByWindowBackground = true

		// add swiftui view

		contentView = NSHostingView(rootView: AppView())

		// track window frame changes

		addNotificationObserver(for: NSWindow.didMoveNotification) { _ in self.resetWindowFrame() }
		addNotificationObserver(for: NSWindow.didResizeNotification) { _ in self.resetWindowFrame() }
		addNotificationObserver(for: NSApplication.didChangeScreenParametersNotification)

		// track menu bar visibility

		addNotificationObserver(for: UserDefaults.didChangeNotification)
		addDefaultsObserver(for: \.AppleMenuBarVisibleInFullscreen)
		addDefaultsObserver(for: \._HIHideMenuBar)
		// TODO: update level to show above menu bar?
	}

	deinit {

		// disable observers

		for observer in notificationObservers {
			NotificationCenter.default.removeObserver(observer)
		}
		for observer in userDefaultsObservers {
			observer.invalidate()
		}

		// clear observers

		notificationObservers.removeAll()
		userDefaultsObservers.removeAll()
	}

	// observer helpers

	private func addNotificationObserver(
		for name: NSNotification.Name,
		action: @escaping (Notification) -> Void = { _ in }
	) {
		notificationObservers.append(NotificationCenter.default.addObserver(
			forName: name,
			object: nil,
			queue: nil
		) { notification in
			print(">", notification.name.rawValue)
			action(notification)
		})
	}

	private func addDefaultsObserver(
		for keyPath: KeyPath<UserDefaults, Bool>,
		action: @escaping (UserDefaults, NSKeyValueObservedChange<Bool>) -> Void = { _, _ in }
	) {
		userDefaultsObservers.append(UserDefaults.standard.observe(
			keyPath,
			options: [.initial, .new],
			changeHandler: { defaults, change in
				print(">", keyPath.description, change.newValue ?? "nil")
				action(defaults, change)
			}
		))
	}

	// reset window frame

	private func resetWindowFrame() {

		// ensure built-in screen is available

		guard let screen = NSScreen.builtIn else {

			// quit application

			return NSApplication.shared.terminate(self)
		}

		// ensure notch area is available

		guard screen.notch != nil else {

			// quit application

			return NSApplication.shared.terminate(self)
		}

		// get window values

		let width = self.frame.width
		let height = self.frame.height
		let x = self.frame.origin.x
		let y = self.frame.origin.y

		// get screen values

		let size = screen.frame.size
		let origin = screen.frame.origin

		// check window size

		if width != size.width || height != size.height {
			print("Window size changed.")

			// reset window size

			self.setContentSize(size)
		}

		// check window position

		if x != origin.x || y != origin.y {
			print("Window position changed.")

			// reset window position

			self.setFrameOrigin(origin)
		}

		// hide window when covered

//		self.alphaValue = screen.canShowNotchBar ? 1 : 0
		// TODO: indicate to user that notchbar is covered?
	}
}
