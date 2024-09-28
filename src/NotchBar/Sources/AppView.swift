import SwiftUI

struct AppView: View {

	@State var state = AppState.shared

	let notchHeight = NSScreen.builtIn?.notch?.height ?? 31.5

	var body: some View {
		VStack(spacing: 0) {

			// Notch Bar

			HStack {
				Text("NotchBar")
					.padding()
					.background(.green)
					.cornerRadius(10)
					.onTapGesture {
						state.toggleSettings()
					}
			}
			.frame(maxWidth: .infinity, maxHeight: notchHeight, alignment: .leading)
			.background(.blue)
			.padding(.horizontal)

			// TODO: add inverted bottom corners view (based on preferences)

			// Settings

			if state.window.is(.settings) {
				VStack {
					Text("Settings")
					Text("Quit App")
						.padding()
						.background(.orange)
						.cornerRadius(10)
						.onTapGesture {
							NSApplication.shared.terminate(self)
						}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(.blue)
				.cornerRadius(10)
				.padding()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.background(.red)
		.preferredColorScheme(.dark)
	}
}

#Preview {
	AppView()
}
