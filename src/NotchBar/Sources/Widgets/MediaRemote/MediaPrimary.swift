import SwiftUI

struct MediaPrimary: View {
	private let media = MediaData.shared

	@Binding var expand: Bool

	@State private var isHovered = false
	var body: some View {
		if let track = media.track {
			HStack {

				// Group (Hover Area)

				ZStack {
					let size: CGFloat = 24
					if let artworkData = track.artworkData,
					   let image = NSImage(data: artworkData),
					   let background = image.averageColor {

						// Artwork

						Image(nsImage: image)
							.resizable()
							.scaledToFit()
							.frame(width: size)

						if isHovered {

							// Play/Pause Button

							let isLightBackground = background.luminance > 0.5

							Image(systemSymbol: media.isPlaying ? .pauseFill : .playFill)
								.foregroundStyle(isLightBackground ? .black : .white)
								.contentTransition(.symbolEffect)
						}
					} else {

						// Fallback Symbol

						HStack(spacing: 0) {

							if isHovered {

								// Play/Pause Button

								let isLightBackground = false

								Image(systemSymbol: media.isPlaying ? .pauseFill : .playFill)
									.foregroundStyle(isLightBackground ? .black : .white)
									.contentTransition(.symbolEffect)
									.frame(width: size - 1)
							} else {

								Image(systemSymbol: .musicNote)
									.frame(width: size - 1)
							}
							Divider()
						}
					}
				}
				.contentShape(.rect)
				.onTapGesture(count: 1) {
					media.command(.TogglePlayPause)
				}

				// Artist

				if !track.artist.isEmpty {
					Text(track.artist)
					Divider()
				}

				// Title

				Text(track.title.isEmpty ? "Unknown" : track.title)
					.lineLimit(1)
					.truncationMode(.tail)
					.foregroundStyle(media.isPlaying ? .primary : .secondary)
			}
//			.padding(.horizontal, 4)
			.padding(.bottom, 2)
			.transition(.movingParts.filmExposure.animation(.smooth))
			.contentShape(.rect)
			.onHover { isHovering in
				isHovered = isHovering
			}
			.onTapGesture {
				expand.toggle()
			}
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	MediaPrimary(expand: $expand)
}
