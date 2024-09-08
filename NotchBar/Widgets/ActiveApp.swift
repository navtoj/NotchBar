//
//  ActiveApp.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-05.
//

import SwiftUI
import SFSafeSymbols

struct ActiveApp: View {
	let app: NSRunningApplication?
		
		var body: some View {
			if let app = app {
				HStack {
					if let icon = app.icon {
						Image(nsImage: icon)
							.resizable()
							.scaledToFit()
					} else {
						Image(systemSymbol: .macwindow)
					}
					Text(app.localizedName ?? "Unknown")
				}
				.padding(.horizontal, 10)
				.padding(.vertical, 4)
				.background(.background)
				.clipShape(.capsule(style: .continuous))
				.onHover(perform: { hovering in
					print("hovering", hovering)
				})
				.onTapGesture(count: 1, perform: {
					print("tapped")
				})
			}
		}
}

#Preview {
	ActiveApp(app: .current)
}
