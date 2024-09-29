import SwiftUI

struct AppView: View {

	@State var state = AppState.shared

	let notchHeight = NSScreen.builtIn?.notch?.height ?? 31.5

	var body: some View {

		// Full Screen Container

		VStack(spacing: 0) {

			// Notch Bar

			HStack {

				// Widgets
				// –> Primary   : .frame(maxHeight: notchHeight)
				// –> Secondary : ..?

				Text("NotchBar")
					.padding(5)
					.background(.blue)
					.cornerRadius(10)
					.frame(maxHeight: notchHeight)
					.onTapGesture {
						state.toggleSettings()
					}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal)
			.background(.black)

			// TODO: add inverted bottom corners view (based on preferences)

			// Settings

			if state.window.is(.settings) {
				VStack(spacing: 0) {

					Text("Settings")
						.textCase(.uppercase)
						.font(.headline)
						.padding()

					Text("Quit App")
						.padding(5)
						.background(.red)
						.cornerRadius(10)
						.onTapGesture {
							NSApp.terminate(self)
						}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(.background)
				.cornerRadius(10)
				.padding()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.preferredColorScheme(.dark)
	}
}

#Preview {
	AppView()
}
