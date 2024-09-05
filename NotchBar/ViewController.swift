//
//  ViewController.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
	
	override func loadView() {
		
		view = NSHostingView(rootView: ContentView())
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
