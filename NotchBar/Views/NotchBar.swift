//
//  NotchBar.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI

struct NotchBar: View {
	@Environment(\.colorScheme) var theme
	
	@StateObject private var systemInfoData = SystemInfoData.shared
	@StateObject private var activeAppData = ActiveAppData.shared
	@StateObject private var mediaRemoteData = MediaRemoteData.shared
	
	let notch = NSScreen.builtIn?.notchFrame
	
	var body: some View {
		HStack(spacing: notch?.width) {
			HStack {
				SystemInfo(info: systemInfoData.systemInfo)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			HStack {
				MediaRemote(info: mediaRemoteData.mediaRemoteInfo)
				ActiveApp(app: activeAppData.activeApp)
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
