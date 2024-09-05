//
//  ContentView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI

struct ContentView: View {
	
	let notch = NSScreen.builtIn?.notchFrame
	
	var body: some View {
		VStack {
			HStack(spacing: notch?.width) {
				HStack {
					Image(systemName: "sparkle")
					Spacer()
					Image(systemName: "sparkle")
					// SystemInfo(info: delegate.appData.systemInfo)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				HStack {
					Image(systemName: "sparkle")
					Spacer()
					Image(systemName: "sparkle")
					// ActiveApp(app: delegate.appData.activeApp)
				}
				.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.padding(.horizontal, 4)
			.padding(.vertical, 2)
			.frame(height: notch?.height ?? 31.5)
			.preferredColorScheme(.dark)
			.background(.black)
			.foregroundStyle(.primary)
		}
		.frame(maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	ContentView()
}
