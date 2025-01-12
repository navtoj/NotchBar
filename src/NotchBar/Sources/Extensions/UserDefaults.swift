import SwiftUI

extension UserDefaults {

	// create keys from strings

	@objc dynamic var AppleMenuBarVisibleInFullscreen: Bool {
		return bool(forKey: "AppleMenuBarVisibleInFullscreen")
	}

	@objc dynamic var _HIHideMenuBar: Bool {
		return bool(forKey: "_HIHideMenuBar")
	}
}
extension KeyPath where Root == UserDefaults {

	var description: String {

		// clean key path

		let keyPath = self.debugDescription.replacingOccurrences(of: "\\NSUserDefaults.", with: "")

		// customize key path

		return keyPath == "_HIHideMenuBar" ? "AppleMenuBarHiddenOnDesktop" : keyPath
	}
}

extension UserDefaults {

	/// Return a value indicating the menu bar status.
	final var menuBarAutoHide: MenuBarAutoHide {

		// get menu bar status

		return MenuBarAutoHide.status(
			AppleMenuBarVisibleInFullscreen: AppleMenuBarVisibleInFullscreen,
			_HIHideMenuBar: _HIHideMenuBar
		)
	}
}
enum MenuBarAutoHide: String, CaseIterable, Identifiable {
	var id: Self { self }

	case always = "Always"
	case onDesk = "On Desktop Only"
	case inFull = "In Full Screen Only"
	case never = "Never"

	public var visibleInFullscreen: Bool {
		switch self {
			case .always, .inFull: return false
			case .onDesk, .never: return true
		}
	}

	public var autohideOnDesktop: Bool {
		switch self {
			case .always, .onDesk: return true
			case .inFull, .never: return false
		}
	}

	static func status(
		AppleMenuBarVisibleInFullscreen visibleInFullscreen	: Bool,
		_HIHideMenuBar 					autohideOnDesktop	: Bool
	) -> MenuBarAutoHide {
		switch (visibleInFullscreen, autohideOnDesktop) {
			case (false, true): return .always
			case (true, true): return .onDesk
			case (false, false): return .inFull
			case (true, false): return .never
		}
	}
}
