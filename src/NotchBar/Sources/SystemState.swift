import AppKit
import SwiftUICore

// TODO: indicate to user that notchbar is covered?

@Observable
final class SystemState {

	// create singleton instance

	static let shared = SystemState()

	// state properties

	private(set) var isMenuBarHidden = NSScreen.builtIn.isMenuBarHidden
	private(set) var menuBarAutoHide = UserDefaults.standard.menuBarAutoHide

	// hold observers for deinit

	private var notifications: [NSObjectProtocol] = []
	private var userDefaults: [NSKeyValueObservation] = []

	// disallow direct instantiation

	private init() {

		// track menu bar visibility

		addNotificationObserver(to: &notifications, for: NSWindow.didMoveNotification) { _ in
			self.isMenuBarHidden = NSScreen.builtIn.isMenuBarHidden
		}

		// track menu bar settings

		addUserDefaultsObserver(to: &userDefaults, for: \.AppleMenuBarVisibleInFullscreen) { _,_ in
			self.menuBarAutoHide = UserDefaults.standard.menuBarAutoHide
		}
		addUserDefaultsObserver(to: &userDefaults, for: \._HIHideMenuBar) { _,_ in
			self.menuBarAutoHide = UserDefaults.standard.menuBarAutoHide
		}
	}

	deinit {

		// disable observers

		for observer in notifications {
			NotificationCenter.default.removeObserver(observer)
		}
		for observer in userDefaults {
			observer.invalidate()
		}

		// clear observers

		notifications.removeAll()
		userDefaults.removeAll()
	}
}
