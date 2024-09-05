//
//  BuiltInScreen.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import AppKit

extension NSScreen {
	
	/// Returns a screen object representing the built-in screen.
	class var builtIn: NSScreen? {
		
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
}
