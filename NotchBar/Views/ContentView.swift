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
		}
		.frame(maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	ContentView()
}
