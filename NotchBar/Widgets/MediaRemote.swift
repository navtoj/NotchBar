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
			HStack {
				if info.isPlaying {
					if let nowPlaying = info.nowPlaying {
						if let artwork = nowPlaying.artwork {
							Image(nsImage: artwork)
								.resizable()
								.scaledToFit()
						} else {
							if let icon = info.application?.icon {
								Image(nsImage: icon)
									.resizable()
									.scaledToFit()
							} else {
								Image(systemSymbol: .musicNote)
									.resizable()
									.scaledToFit()
							}
						}
						Text(nowPlaying.artist)
						Divider()
						Text(nowPlaying.title)
							.lineLimit(1)
							.truncationMode(.tail)
					}
				}
			}
#if DEBUG
			.border(.red)
#endif
			.padding(.leading, 4)
//			.padding(.vertical, 4)
#if DEBUG
			.border(.blue)
#endif
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}

#Preview {
	MediaRemote(info: MediaRemoteData.shared.mediaRemoteInfo)
}
