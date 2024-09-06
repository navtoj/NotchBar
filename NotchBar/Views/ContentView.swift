//
//  ContentView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI

struct ContentView: View {
	
	var body: some View {
		VStack {
			NotchBar()
				.invertedBottomCorners(background: .black, radius: 10)
		}
		.frame(maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	ContentView()
		.frame(minWidth: NSScreen.builtIn?.frame.width)
}
