import AppKit
import SwiftUICore

// TODO: indicate to user that notchbar is covered?
// TODO: update level to show above menu bar?

@Observable
final class AppState {

	// create singleton instance

	static let shared = AppState()

	// state properties

	enum WindowView {
		case welcome
		case settings

		@ViewBuilder
		var view: some View {
			switch self {
				case .welcome: Welcome()
				case .settings: Settings()
			}
		}
	}

	private(set) var window: WindowView?
	private(set) var canShowNotchBar: Bool

	// hold observers for deinit

	private var notifications: [NSObjectProtocol] = []
	private var userDefaults: [NSKeyValueObservation] = []

	// disallow direct instantiation

	private init() {
#if DEBUG
		print("AppState init")
#endif

		// make sure built-in screen is available

		guard let screen = NSScreen.builtIn else {

			// quit application

			fatalError("Built-in screen not found.")
		}

		// set initial state

		canShowNotchBar = screen.canShowNotchBar

		// track menu bar visibility

		addNotificationObserver(to: &notifications, for: UserDefaults.didChangeNotification)
		addUserDefaultsObserver(to: &userDefaults, for: \.AppleMenuBarVisibleInFullscreen)
		addUserDefaultsObserver(to: &userDefaults, for: \._HIHideMenuBar)
	}

	func toggleSettings() {
		window = window == .settings ? .none : .settings
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
