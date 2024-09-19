//
//  MediaRemote.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-12.
//

import SwiftUI

struct MediaRemote: View {
	private var mediaRemoteData = MediaRemoteData.shared
	
	@State private var isHovered = false
	
	var body: some View {
		let data: MediaRemoteData = mediaRemoteData
		
		if data.isPlaying,
		   let track = data.track {
			HStack {
				
				// Group (Hover Area)
				
				HStack {
					if let artworkData = track.artworkData,
					   let image = NSImage(data: artworkData) {
						
						// Artwork
						
						Image(nsImage: image)
							.resizable()
							.scaledToFit()
							.frame(width: 24)
					} else {
						
						// Fallback Symbol
						
						HStack(spacing: 0) {
							Image(systemSymbol: .musicNote)
								.frame(width: 23)
							Divider()
						}
					}
					
					// Artist
					
					Text(track.artist)
					Divider()
				}
				.contentShape(.rect)
				.onHover { isHovering in
					isHovered = isHovering
				}
				
				// Title & Album (on Hover)
				
				Text(isHovered ? track.album : track.title)
					.lineLimit(1)
					.truncationMode(.tail)
					.conditionalEffect(.pushDown, condition: isHovered)
			}
			.transition(.movingParts.filmExposure.animation(.smooth))
//#if DEBUG
//			.border(.red)
//#endif
			.padding(.leading, 4)
			.padding(.vertical, 2)
//#if DEBUG
//			.border(.blue)
//#endif
			.frame(maxWidth: .infinity, alignment: .leading)
//#if DEBUG
//			.border(.green)
//#endif
		}
	}
}

#Preview {
	MediaRemote()
}
