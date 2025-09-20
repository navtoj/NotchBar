import AXSwift
import Defaults
import LaunchAtLogin
import SwiftUI

// MARK: - BarView

struct BarView: View {
	// MARK: Properties

	@Default(.roundCorners) var roundCorners

	/// `Black`
	let backgroundColor = Color.black
	/// `White`
	let foregroundColor = Color.white

	// MARK: Content Properties

	var body: some View {
		VStack(spacing: 0) {
			HStack {
				if let bundle = Bundle.main.bundleIdentifier {
					Text(bundle)
						.foregroundStyle(foregroundColor)
				}
			}
			.padding(.horizontal)
			.frame(
				maxWidth: .infinity,
				minHeight: NSScreen.builtIn?.notch?.height,
				maxHeight: NSScreen.builtIn?.notch?.height,
				alignment: .leading
			)
			.background(backgroundColor)
			if roundCorners {
				Rectangle()
					.fill(backgroundColor)
					.frame(height: 10)
					.clipShape(InvertedBottomCorners(radius: 10))
			}
			if DEBUG {
				VStack {
					if !AX.shared.isTrusted {
						Button("Enable Accessibility Access") { checkIsProcessTrusted(prompt: true) }
					}
				}
				.padding()
				.background()
				.cornerRadius()
			}
		}
		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .top
		)
	}
}

#Preview {
	BarView()
}
