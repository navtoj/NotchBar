import SwiftUI

struct AppView: View {
	private let notch = NSScreen.builtIn!.notch!

	@State var state = AppState.shared

	var body: some View {

		// App Container

		VStack(spacing: 0) {

			// Notch Bar

			HStack(spacing: notch.width) { // TODO: keep widgets within bounds w/ ViewThatFits?

				// Widgets - Left

				HStack {
					WidgetView<SystemInfoPrimary, Never>(primary: SystemInfoPrimary.init)
//					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
				}
				.frame(maxWidth: notch.minX, alignment: .leading)

				// Widgets - Right

				HStack {
					HStack {
						WidgetView(
							primary: MediaPrimary.init,
							secondary: MediaSecondary.init,
							overlay: .leading
						)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					WidgetView<ActiveAppPrimary, Never>(primary: ActiveAppPrimary.init)
				}
				.frame(maxWidth: notch.minX, alignment: .trailing)
			}
			.frame(maxWidth: .infinity, maxHeight: NSScreen.builtIn?.notch?.height ?? 31.5)
			.padding(.horizontal)
			.background(.black)
			.zIndex(1) // otherwise, secondary closes on hover
			.environment(\.colorScheme, .dark)

			// Top Screen Corners

			Color.black
				.frame(height: 10)
				.clipShape(InvertedBottomCorners(radius: 10))

			// Window View

			state.window?.view
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	AppView()
}
