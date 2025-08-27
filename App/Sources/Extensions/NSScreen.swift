import AppKit
import SwiftUI

extension NSScreen {
	/// Returns a screen object representing the built-in screen.
	static var builtIn: NSScreen? {
		// loop through available screens

		NSScreen.screens.first { screen in
			// get screen dictionary

			let description = screen.deviceDescription

			// create dictionary key

			let screenNumber = NSDeviceDescriptionKey("NSScreenNumber")

			// get value from dictionary

			guard let displayID = description[screenNumber] as? CGDirectDisplayID else {
				// continue loop

				return false
			}

			// check if display is built-in

			let isBuiltIn = CGDisplayIsBuiltin(displayID)

			// convert boolean_t (Int32) to boolean

			return isBuiltIn != 0
		}
	}

	/// Returns the frame of the notch area.
	final var notch: NSRect? {
		// ensure auxiliary areas are available

		guard let leftArea = auxiliaryTopLeftArea,
		      let rightArea = auxiliaryTopRightArea else { return nil }

		// ensure notch height is consistent

		let notchHeight = safeAreaInsets.top

		guard notchHeight == leftArea.height,
		      notchHeight == rightArea.height else { return nil }

		// calculate notch frame

		return NSRect(
			x: leftArea.maxX,
			y: leftArea.minY,
			width: rightArea.minX - leftArea.maxX,
			height: notchHeight
		)
	}

	final var isMenuBarVisible: Bool {
		let height = abs(frame.maxY - visibleFrame.maxY)
		let offset = notch?.height ?? 0
		return (height - offset) > 0
	}
}
