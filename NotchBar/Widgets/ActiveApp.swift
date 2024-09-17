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
					.id(app)
					.transition(.opacity.animation(.easeOut))
//					.transition(.asymmetric(insertion: .offset(y: -25), removal: .opacity))
				if let icon = app.icon {
					Image(nsImage: icon)
						.resizable()
						.scaledToFit()
						.id(app)
						.transition(.opacity.animation(.easeOut))
				} else {
					Image(systemSymbol: .macwindow)
				}
			}
//#if DEBUG
//			.border(.red)
//#endif
			.padding(.horizontal, 10)
			.padding(.vertical, 4)
//#if DEBUG
//			.border(.blue)
//#endif
			.background(.fill)
			.clipShape(.capsule(style: .continuous))
			.animation(.movingParts.overshoot, value: app)
		}
	}
}

#Preview {
	ActiveApp()
}
