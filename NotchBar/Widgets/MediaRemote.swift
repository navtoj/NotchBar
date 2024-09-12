//
//  MediaRemote.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-12.
//

import SwiftUI

struct MediaRemote: View {
	let info: MediaRemoteInfo?
	
	var body: some View {
		if let info = info {
			if info.isPlaying {
				if let title = info.title {
					Label(title, systemSymbol: .musicNote)
						.padding(.horizontal, 10)
				}
			}
		}
	}
}

#Preview {
	MediaRemote(info: MediaRemoteData.shared.mediaRemoteInfo)
}
