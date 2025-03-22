import SwiftUI

final class AppWindow: NSWindow {

	// create singleton instance

	static let shared = AppWindow()

	// hold observers for deinit

	private var notifications: [NSObjectProtocol] = []

	// disallow direct instantiation

	private init() {

		// create window

		super.init(
			contentRect: NSScreen.builtIn.frame,
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

		// get window values

		let width = self.frame.width
		let height = self.frame.height
		let x = self.frame.origin.x
		let y = self.frame.origin.y

		// get screen values

		let size = NSScreen.builtIn.frame.size
		let origin = NSScreen.builtIn.frame.origin

		// check window size

		if width != size.width || height != size.height {

			// reset window size

			self.setContentSize(size)
		}

		// check window position

		if x != origin.x || y != origin.y {

			// reset window position

			self.setFrameOrigin(origin)
		}
	}
}
