import SwiftUI
import LaunchAtLogin

struct Settings: View {
	@State var size: CGSize = .zero

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {

			// Title Bar

			HStack(spacing: 10) {

				// Close Button

				Button(action: {
					AppState.shared.hideCard()
				}) {
					Image(systemSymbol: .xmark)
						.padding(.vertical, 5)
				}

				// Window Title

				Text("Settings")
					.font(.title)
			}
			.padding(10)
			.onSizeChange(sync: $size, if: .max)

			// Divider

			Divider()
				.frame(width: size.width)

			// Content

			VStack {
				// TODO: configure widgets: visibility, order, etc.

				LaunchAtLogin.Toggle()
			}
			.padding()
			.onSizeChange(sync: $size, if: .max)
		}
	}
}

#Preview {
	Settings()
}
