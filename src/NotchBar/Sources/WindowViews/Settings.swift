import SwiftUI

struct Settings: View {
	@State var state = AppState.shared

	var body: some View {
		VStack(spacing: 0) {

			// Title Bar

			HStack {

				// Window Title

				Text("Settings")
					.font(.title)

				Spacer()

				// Close Button

				Button(action: {
					state.removeCard()
				}) {
					Image(systemSymbol: .xmark)
						.padding(.vertical, 5)
				}
			}
			.padding()
			.frame(maxWidth: .infinity, alignment: .leading)

			// Divider

			Divider()

			// Content

			VStack {
				// TODO: configure widgets: visibility, order, etc.

				Button("Quit App", role: .destructive) {
					NSApp.terminate(self)
				}
			}
			.padding()
			.frame(maxHeight: .infinity)
		}
		.frame(maxWidth: 300, maxHeight: 300)
	}
}

#Preview {
	Settings()
}
