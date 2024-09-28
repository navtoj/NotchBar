//
//  UserDefaults.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-27.
//

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
