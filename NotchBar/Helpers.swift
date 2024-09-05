//
//  Helpers.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import AppKit

func QuitWithLog(_ message: String, sender: Any? = nil) {
	
	// Log Message
	print(message)
	
	// Quit App
	NSApplication.shared.terminate(sender)
}
