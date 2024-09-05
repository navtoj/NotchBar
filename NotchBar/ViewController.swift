//
//  ViewController.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa

class ViewController: NSViewController {
	
	override func loadView() {
		
		// Create Base View
		
		view = NSView()
		
//		view.wantsLayer = true
//		view.layer?.backgroundColor = .black
//		view.layer?.borderWidth = 10
//		view.layer?.borderColor = .white
		
		// Create Notch Area
		
		let notchArea = NSView(
			frame: NSRect(
				origin: CGPoint(x: 0, y: 950),
				size: CGSize(
					width: (NSScreen.builtIn?.frame.width)!,
					height: (NSScreen.builtIn?.notchFrame!.height)!
				)
			)
		)
		
		notchArea.wantsLayer = true
		notchArea.layer?.backgroundColor = .black
		
		// Add Notch Area
		
		view.addSubview(notchArea)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
}
