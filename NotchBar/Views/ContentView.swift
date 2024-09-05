//
//  ContentView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject private var appState = AppState.shared
	
	var body: some View {
		VStack {
			NotchBar()
				.opacity(appState.isBarCovered ? 0 : 1)
		}
		.frame(maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	ContentView()
}
