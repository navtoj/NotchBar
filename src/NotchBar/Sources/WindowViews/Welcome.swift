import SwiftUI
import Defaults

struct Welcome: View {
	@State var systemState = SystemState.shared

	@State var size: CGSize = .zero

	var body: some View {
		VStack {

			// Title Bar

			HStack(spacing: 0) {
				Text("Welcome to ")
					.foregroundStyle(.secondary)

				Text("NotchBar")
			}
			.font(.title)
			.bold()
			.onSizeChange(sync: $size, if: .max)

			Divider()
				.frame(maxWidth: size.width)
				.padding(.bottom, 5)
			
			Text("Tap the 􀫸 status item for settings.")
				.onSizeChange(sync: $size, if: .max)
		}
		.padding()
		.onDisappear {
			Defaults[.skipWelcome] = true
		}
	}
}

#Preview {
	Welcome()
}
