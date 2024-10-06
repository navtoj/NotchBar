import SwiftUI

final class AppWindow: NSWindow {

	// create singleton instance

	static let shared = AppWindow()

	// hold observers for deinit

	private var notifications: [NSObjectProtocol] = []

	// disallow direct instantiation

	private init() {
		print("AppWindow init")

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

		// add swiftui view

		contentView = NSHostingView(rootView: AppView())

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

		// track window frame changes

		addNotificationObserver(to: &notifications, for: NSWindow.didMoveNotification) { _ in self.resetWindowFrame() }
		addNotificationObserver(to: &notifications, for: NSWindow.didResizeNotification) { _ in self.resetWindowFrame() }
		addNotificationObserver(to: &notifications, for: NSApplication.didChangeScreenParametersNotification)
	}

	deinit {

		// disable observers

		for observer in notifications {
			NotificationCenter.default.removeObserver(observer)
		}

		// clear observers

		notifications.removeAll()
	}

	// reset window frame

	private func resetWindowFrame() {

		// ensure built-in screen is available

		guard let screen = NSScreen.builtIn else {

			// quit application

			return NSApp.terminate(self)
		}

		// ensure notch area is available

		guard screen.notch != nil else {

			// quit application

			return NSApp.terminate(self)
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
	}
}
