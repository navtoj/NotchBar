//
//  ActiveApp.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-05.
//

import SwiftUI

struct ActiveApp: View {
	private var activeAppData = ActiveAppData.shared
	
	var body: some View {
		if let app = activeAppData.activeApp {
			HStack {
				Text(app.localizedName ?? "Unknown")
				if let icon = app.icon {
					Image(nsImage: icon)
						.resizable()
						.scaledToFit()
				} else {
					Image(systemSymbol: .macwindow)
				}
			}
#if DEBUG
			.border(.red)
#endif
			.padding(.horizontal, 10)
			.padding(.vertical, 4)
#if DEBUG
			.border(.blue)
#endif
			.background(.fill)
			.clipShape(.capsule(style: .continuous))
			.onHover(perform: { hovering in
				print("hovering", hovering)
			})
			.onTapGesture(count: 1, perform: {
				print("tapped")
			})
			.animation(.movingParts.easeInOutExponential, value: app)
		}
	}
}

#Preview {
	ActiveApp()
}
