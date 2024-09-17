//
//  MediaRemote.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-12.
//

import SwiftUI

struct MediaRemote: View {
	private var mediaRemoteData = MediaRemoteData.shared
	
	@State private var showAlbum = false
	
	var body: some View {
		let data: MediaRemoteData = mediaRemoteData
		
		if data.isPlaying,
		   let track = data.track {
			HStack {
				Group {
					if let artworkData = track.artworkData,
					   let image = NSImage(data: artworkData) {
						Image(nsImage: image)
							.resizable()
							.scaledToFit()
							.frame(width: 24)
					} else {
						HStack(spacing: 0) {
							Image(systemSymbol: .musicNote)
								.frame(width: 23)
							Divider()
						}
					}
					Text(track.artist)
					Divider()
				}
				.onHover { isHovering in
					showAlbum = isHovering
				}
				Text(showAlbum ? track.album : track.title)
					.lineLimit(1)
					.truncationMode(.tail)
					.conditionalEffect(.pushDown, condition: showAlbum)
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
			.transition(.movingParts.filmExposure.animation(.smooth))
		}
	}
}

#Preview {
	MediaRemote()
}
