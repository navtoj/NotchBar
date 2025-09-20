import AppKit

// MARK: - SystemState

@Observable
final class SystemState {
	// MARK: Static Properties

	static let shared = SystemState()

	// MARK: Properties

	/// Maps to the `Automatically hide and show the menu bar` user setting.
	private(set) var menuBarAutoHide = MenuBarAutoHide.status(
		AppleMenuBarVisibleInFullscreen: UserDefaults.standard.AppleMenuBarVisibleInFullscreen,
		_HIHideMenuBar: UserDefaults.standard._HIHideMenuBar
	)

	private var userDefaults: [NSKeyValueObservation] = []

	// MARK: Lifecycle

	deinit {
		for observer in userDefaults {
			observer.invalidate()
		}

		userDefaults.removeAll()
	}

	private init() {
		addUserDefaultsObserver(to: &userDefaults, for: \.AppleMenuBarVisibleInFullscreen) { _, change in
			self.menuBarAutoHide = MenuBarAutoHide.status(
				AppleMenuBarVisibleInFullscreen: change.newValue ?? UserDefaults.standard.AppleMenuBarVisibleInFullscreen,
				_HIHideMenuBar: UserDefaults.standard._HIHideMenuBar
			)
		}

		addUserDefaultsObserver(to: &userDefaults, for: \._HIHideMenuBar) { _, change in
			self.menuBarAutoHide = MenuBarAutoHide.status(
				AppleMenuBarVisibleInFullscreen: UserDefaults.standard.AppleMenuBarVisibleInFullscreen,
				_HIHideMenuBar: change.newValue ?? UserDefaults.standard._HIHideMenuBar
			)
		}
	}
}

// MARK: - MenuBarAutoHide

enum MenuBarAutoHide: String, CaseIterable, Identifiable {
	case always = "Always"
	case onDesk = "On Desktop Only"
	case inFull = "In Full Screen Only"
	case never = "Never"

	// MARK: Computed Properties

	var id: String { rawValue }

	var hiddenOnDesktop: Bool {
		switch self {
			case .always,
			     .onDesk: true
			case .inFull,
			     .never: false
		}
	}

	var visibleInFullscreen: Bool {
		switch self {
			case .always,
			     .inFull: false
			case .never,
			     .onDesk: true
		}
	}

	// MARK: Static Functions

	static func status(
		AppleMenuBarVisibleInFullscreen visibleInFullscreen: Bool,
		_HIHideMenuBar hiddenOnDesktop: Bool
	) -> MenuBarAutoHide {
		switch (visibleInFullscreen, hiddenOnDesktop) {
			case (false, true): .always
			case (true, true): .onDesk
			case (false, false): .inFull
			case (true, false): .never
		}
	}
}
