import SwiftUI

extension UserDefaults {
	@objc dynamic var AppleMenuBarVisibleInFullscreen: Bool {
		bool(forKey: "AppleMenuBarVisibleInFullscreen")
	}

	@objc dynamic var _HIHideMenuBar: Bool {
		bool(forKey: "_HIHideMenuBar")
	}
}

extension KeyPath where Root == UserDefaults {
	var description: String {
		debugDescription.replacingOccurrences(of: "\\NSUserDefaults.", with: "")
	}
}
