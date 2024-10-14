import SwiftUI
import SFSafeSymbols

struct MediaSecondary: View {
	private let media = MediaData.shared

	@Binding var expand: Bool

	@State private var controls: CGSize = .zero
	@State private var albumName: CGSize = .zero
	var body: some View {
		VStack(spacing: 4) {
			if let track = media.track {

				// Controls
				
				HStack(spacing: 0) {
					// FIXME: "The command did not provide a status"
					// kMRMediaRemoteNowPlayingInfoSupports{command}

					MediaControl(symbol: .backwardEnd, command: .PreviousTrack)
					MediaControl(symbol: .backward, command: .Rewind15Seconds)
					MediaControl(symbol: .forward, command: .FastForward15Seconds)
					MediaControl(symbol: .forwardEnd, command: .NextTrack)
				}
				.background(.background)
				.onSizeChange(sync: $controls)

				// Album

				if !track.album.isEmpty {
					Group {
						if albumName.width > controls.width {
							Marquee(targetVelocity: 10) {
								Text(track.album)
									.font(.caption)
									.fixedSize()
									.onSizeChange(sync: $albumName)
							}
						} else {
							Text(track.album)
								.font(.caption)
								.fixedSize()
								.onSizeChange(sync: $albumName)
								.frame(maxWidth: .infinity)
						}
					}
					.padding(5)
					.background(.background)
				}

				// Artwork

				if let artworkData = track.artworkData,
				   let image = NSImage(data: artworkData) {
					Image(nsImage: image)
						.resizable()
						.scaledToFill()
				}
			}
		}
		.frame(width: controls.width)
		.roundedCorners(5, width: 4)
    }
}

#Preview {
	@Previewable @State var expand = true
	MediaSecondary(expand: $expand)
}

private struct MediaControl: View {
	let symbol: SFSymbol
	let command: MRMediaRemoteCommand

	var body: some View {
		Image(systemSymbol: symbol)
			.padding(.horizontal)
			.padding(.vertical, 10)
			.contentShape(.rect)
			.onTapGesture {
				MediaData.shared.command(command)
			}
	}
}
