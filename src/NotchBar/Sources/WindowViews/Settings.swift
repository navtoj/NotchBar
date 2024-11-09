import SwiftUI
import LaunchAtLogin
import SFSafeSymbols

struct Settings: View {
	@State var size: CGSize = .zero
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {

			// Title Bar

			HStack(spacing: 10) {

				// Window Title

				Text("Settings")
					.font(.title)
					.fixedSize()

				// Close Button

				Button(action: {
					AppState.shared.hideCard()
				}) {
					Image(systemSymbol: .xmark)
						.padding(.vertical, 5)
				}
				.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.padding(10)
			.onSizeChange(sync: $size, if: .max)

			// Divider

			Divider()

			// Content

			VStack {
				// TODO: configure widgets: visibility, order, etc.

				LaunchAtLogin.Toggle()
			}
			.padding()
			.onSizeChange(sync: $size, if: .max)

			// Divider

			Divider()

			// Widgets

			WidgetsLayout()
				.onSizeChange(sync: $size, if: .max)
		}
		.frame(width: size.width)
	}
}

#Preview {
	Settings()
}
