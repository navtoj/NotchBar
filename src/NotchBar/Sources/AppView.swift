import SwiftUI

struct AppView: View {
	private let notch = NSScreen.builtIn!.notch!

	@State var state = AppState.shared

	var body: some View {

		// App Container

		VStack(spacing: 0) {

			// Notch Bar

			HStack(spacing: notch.width) {
				// TODO: use ViewThatFits to keep widgets within bounds

				// Widgets - Left

				HStack {
					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
				}
				.frame(maxWidth: notch.minX, alignment: .leading)
#if DEBUG
				.border(.red)
#endif

				// Widgets - Right

				HStack {
					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
					WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
				}
				.frame(maxWidth: notch.minX, alignment: .trailing)
#if DEBUG
				.border(.red)
#endif
			}
			.frame(maxWidth: .infinity, maxHeight: NSScreen.builtIn?.notch?.height ?? 31.5, alignment: .leading)
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
