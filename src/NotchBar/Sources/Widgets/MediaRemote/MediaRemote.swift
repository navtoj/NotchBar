//
//  MediaRemote.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-10-04.
//

import SwiftUI

struct MediaRemote: View {
	private let mediaData = MediaData.shared

	@Binding var expand: Bool
	
	@State private var isHovered = false
	var body: some View {
		let data: MediaData = mediaData
		
		if let track = data.track {
			HStack {
				
				// Group (Hover Area)
				
				HStack {
					ZStack {
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
						
						if isHovered {
							
							// Play/Pause Button
							
							Image(systemSymbol: data.isPlaying ? .pauseFill : .playFill)
								.contentTransition(.symbolEffect)
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
				.onTapGesture(count: 1) {
					_ = mediaData.SendCommand(.TogglePlayPause)
				}
				
				// Title & Album (on Hover)
				
				let text = isHovered ? (track.album.isEmpty ? track.title : track.album) : track.title
				
				Text(text)
					.lineLimit(1)
					.truncationMode(.tail)
					.conditionalEffect(.pushDown, condition: isHovered)
					.foregroundStyle(data.isPlaying ? .primary : .secondary)
			}
			.transition(.movingParts.filmExposure.animation(.smooth))
			.padding(.leading, 4)
			.padding(.vertical, 2)
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	MediaRemote(expand: $expand)
}
