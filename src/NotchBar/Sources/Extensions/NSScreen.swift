import AppKit

extension NSScreen {

	/// Returns a screen object representing the built-in screen.
	final class var builtIn: NSScreen? {

		// loop through available screens

		return NSScreen.screens.first { screen in

			// get screen dictionary

			let description = screen.deviceDescription

			// create dictionary key

			let screenNumber = NSDeviceDescriptionKey("NSScreenNumber")

			// get value from dictionary

			if let displayId = description[screenNumber] as? CGDirectDisplayID {

				// check if display is built-in

				let isBuiltIn = CGDisplayIsBuiltin(displayId)

				// convert boolean_t (Int32) to boolean

				return isBuiltIn != 0
			}

			// continue loop

			return false
		}
	}

	/// Returns the frame of the notch area.
	final var notch: NSRect? {

		// ensure auxiliary areas are available

		guard let leftArea = self.auxiliaryTopLeftArea else { return nil }
		guard let rightArea = self.auxiliaryTopRightArea else { return nil }

		// ensure notch area is consistent

		let notchHeight = self.safeAreaInsets.top
		guard (
			notchHeight == leftArea.height &&
			notchHeight == rightArea.height
		) else { return nil }

		// calculate notch frame

		return NSRect(
			x: leftArea.maxX,
			y: leftArea.minY,
			width: rightArea.minX - leftArea.maxX,
			height: notchHeight
		)
	}

	/// Return a boolean value indicating whether the notch bar can be shown.
	final var canShowNotchBar: Bool {

		// ensure notch area is available

		guard let notch = self.notch else { return false }

		// compare screen frame with visible frame

		return self.frame.height == (
			self.visibleFrame.height + notch.height
		)
	}

	/// Return a value indicating the menu bar status.
	final var menuBarAutoHide: MenuBarAutoHide {

		// get menu bar status

		let visibleInFullscreen = UserDefaults.standard.AppleMenuBarVisibleInFullscreen
		let autoHideOnDesktop = UserDefaults.standard._HIHideMenuBar

		return MenuBarAutoHide.status(
			visibleInFullscreen: visibleInFullscreen,
			autohideOnDesktop: autoHideOnDesktop
		)
	}
	// TODO: move to more relevant location
}

enum MenuBarAutoHide: String {
	case always = "always"
	case onDesk = "onDesk"
	case inFull = "inFull"
	case never = "never"

	private var visibleInFullscreen: Bool {
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

	static func status(visibleInFullscreen: Bool, autohideOnDesktop: Bool) -> MenuBarAutoHide {
		switch (visibleInFullscreen, autohideOnDesktop) {
			case (false, true): return .always
			case (true, true): return .onDesk
			case (false, false): return .inFull
			case (true, false): return .never
		}
	}
}
