// tccutil reset Accessibility com.navtoj.notchbar
// open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

import AppKit

// TODO: fetch on hover/tap or cache?
func getMenu(of app: NSRunningApplication) -> [MenuItem]? {
//	guard checkPermissions() else { return nil }

	let axApp = AXUIElementCreateApplication(app.processIdentifier)
	guard let bar = get(
		kAXMenuBarAttribute,
		from: axApp,
		errors: [(.apiDisabled, "AX API is disabled.")]
	) as! AXUIElement? else { return nil }

	guard let menu = get(
		kAXChildrenAttribute,
		from: bar
	) as? [AXUIElement] else { return nil }

	return menu.compactMap { item in
		guard let name = get(kAXTitleAttribute, from: item) as? String else { return nil }
		guard [
			// ignore Apple menu
			name != "Apple",
			// ignore app name
			name != app.localizedName
		].allSatisfy({ $0 }) else { return nil }
//		print(name) // Xcode

		return MenuItem(element: item, level: 0, name: name)
	}
}

private func getSubmenu(of item: AXUIElement, level: Int) -> [MenuItem] {
	guard let children = get(kAXChildrenAttribute, from: item) as? [AXUIElement],
		  let dropdown = children.first,
		  let submenu = get(kAXChildrenAttribute, from: dropdown) as? [AXUIElement] else { return [] }
	if children.count > 1 {
		print("!!! Multiple dropdowns found.", children)
	}

	return submenu.compactMap { item in
		guard let name = get(kAXTitleAttribute, from: item) as? String else { return nil }
		guard [
			// ignore separators, search, etc.
			!name.isEmpty
		].allSatisfy({ $0 }) else { return nil }
//		print(String(repeating: " ", count: level), name) // About Xcode

		return MenuItem(
			element: item,
			level: level,
			name: name
		)
	}
}

struct MenuItem: Identifiable, Equatable {
	static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
		lhs.id == rhs.id
	}
	internal let id = UUID()

	private let element: AXUIElement
	let level: Int
	let name: String
	let submenu: [MenuItem]

	init(element: AXUIElement, level: Int, name: String) {
		self.element = element
		self.level = level
		self.name = name
		self.submenu = getSubmenu(of: element, level: level + 1)
	}
}
