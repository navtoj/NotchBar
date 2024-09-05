//
//  NotchBar.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI
import SystemInfoKit

struct NotchBar: View {
	
	@StateObject private var appData = AppData.shared
	
	let notch = NSScreen.builtIn?.notchFrame
	
	var body: some View {
		HStack(spacing: notch?.width) {
			HStack {
				SystemInfo(info: appData.systemInfo)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			HStack {
				ActiveApp(app: appData.activeApp)
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
}

#Preview {
	NotchBar()
		.frame(minWidth: NSScreen.builtIn?.frame.width)
}
