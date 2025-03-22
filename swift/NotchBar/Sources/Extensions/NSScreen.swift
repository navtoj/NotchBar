import AppKit

extension NSScreen {

	/// Returns a screen object representing the built-in screen.
	final class var builtIn: NSScreen {

		// loop through available screens

		let found = NSScreen.screens.first { screen in

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

		// make sure built-in screen is available

		guard let screen = found else {

			// quit application

			fatalError("Built-in screen not found.")
		}

		// return built-in screen

		return screen
	}

	/// Returns the frame of the notch area.
	final var notch: NSRect? {

		// ensure auxiliary areas are available

		guard let leftArea = self.auxiliaryTopLeftArea else { return nil }
		guard let rightArea = self.auxiliaryTopRightArea else { return nil }

		// ensure notch height is consistent

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

	/// Return a boolean value indicating whether the menu bar is hidden.
	final var isMenuBarHidden: Bool {
		self.frame.height == self.visibleFrame.height + (self.notch?.height ?? 0)
	}
}
