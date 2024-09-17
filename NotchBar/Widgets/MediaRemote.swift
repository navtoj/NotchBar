//
//  MediaRemote.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-12.
//

import SwiftUI

struct MediaRemote: View {
	private var mediaRemoteData = MediaRemoteData.shared
	
	var body: some View {
		let data: MediaRemoteData = mediaRemoteData
		
		HStack {
			if data.isPlaying {
				if let track = data.track {
					if let artwork = track.artwork {
						Image(nsImage: artwork)
							.resizable()
							.scaledToFit()
					} else {
						HStack(spacing: 0) {
							Image(systemSymbol: .musicNote)
								.frame(width: 23)
							Divider()
						}
					}
					Text(track.artist)
					Divider()
					Text(track.title)
						.lineLimit(1)
						.truncationMode(.tail)
				}
			}
		}
#if DEBUG
		.border(.red)
#endif
		.padding(.leading, 4)
		.padding(.vertical, 2)
#if DEBUG
		.border(.blue)
#endif
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

#Preview {
	MediaRemote()
}
