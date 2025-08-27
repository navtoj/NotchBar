import Defaults
import LaunchAtLogin
import SwiftUI

struct BarView: View {
	// MARK: Properties

	@Default(.roundCorners) var roundCorners

	let color = Color.black

	// MARK: Content Properties

	var body: some View {
		VStack(spacing: 0) {
			HStack {}
				.padding(.horizontal)
				.frame(
					maxWidth: .infinity,
					maxHeight: NSScreen.builtIn?.notch?.height,
					alignment: .leading
				)
				.background(color)
			if roundCorners {
				Rectangle()
					.fill(color)
					.frame(height: 10)
					.clipShape(InvertedBottomCorners(radius: 10))
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	BarView()
}
