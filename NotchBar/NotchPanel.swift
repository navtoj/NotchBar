//
//  NotchPanel.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa

class NotchPanel: NSWindow {

	init() {
		super.init(
			contentRect: NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1000, height: 1000)),
			styleMask: [
//				.titled
			],
			backing: .buffered,
			defer: false
//			screen: <#T##NSScreen?#>
		)
		
		let vc = ViewController()
		contentView = vc.view
		contentViewController = vc
	}
}
