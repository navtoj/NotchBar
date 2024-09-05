//
//  NotchFrame.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import AppKit

extension NSScreen {
	
	/// Returns the frame of the notch area.
	var notchFrame: NSRect? {
		
		// Ensure Built-in Screen
		
		guard self == NSScreen.builtIn else { return nil }
		
		// Ensure Notch Areas
		
		guard let leftArea = self.auxiliaryTopLeftArea else { return nil }
		guard let rightArea = self.auxiliaryTopRightArea else { return nil }
		
		// Ensure Notch Height
		
		let notchHeight = self.safeAreaInsets.top
		guard (
			notchHeight == leftArea.height &&
			notchHeight == rightArea.height
		) else { return nil }
		
		// Calculate Notch Frame
		
		let x = leftArea.maxX
		let y = leftArea.minY
		let width = rightArea.minX - leftArea.maxX
		let height = notchHeight
		
		// Return Notch Frame
		
		return NSRect(x: x, y: y, width: width, height: height)
	}
}
