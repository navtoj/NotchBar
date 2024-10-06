import SwiftUI

struct Settings: View {
	var body: some View {
		VStack(spacing: 0) {

			Text("Settings")
				.font(.headline)
				.padding()

			Button("Quit App", role: .destructive) {
				NSApp.terminate(self)
			}
		}
		.padding()
		.background(.background)
		.roundedCorners()
	}
}

#Preview {
	Settings()
}
