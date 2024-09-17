//
//  NotchBar.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI

struct NotchBar: View {
	@Environment(\.colorScheme) var theme
	
	let notch = NSScreen.builtIn?.notchFrame
	
	var body: some View {
		HStack(spacing: notch?.width) {
			HStack {
				SystemInfo()
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			HStack {
				MediaRemote()
				ActiveApp()
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
		}
		.padding(.horizontal, 4)
		.padding(.vertical, 2)
		.frame(height: notch?.height ?? 31.5)
		.background(theme == .dark ? .black : Color(.textBackgroundColor))
		.foregroundStyle(.foreground)
	}
}

#Preview {
	NotchBar()
		.frame(minWidth: NSScreen.builtIn?.frame.width)
}
