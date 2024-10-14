import SwiftUI

struct AppView: View {
	private let notch = NSScreen.builtIn!.notch!

	@State var state = AppState.shared

	var body: some View {

		// App Container

		VStack(spacing: 0) {

			// Notch Bar

			HStack(spacing: notch.width) {
				// TODO: keep widgets within bounds w/ ViewThatFits?

				// Widgets - Left

				HStack {
					WidgetView<SystemInfoPrimary, Never>(primary: SystemInfoPrimary.init)
				}
#if DEBUG
				.border(.red)
#endif
				.frame(maxWidth: notch.minX, alignment: .leading)
#if DEBUG
				.border(.blue)
#endif

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
#if DEBUG
				.border(.red)
#endif
				.frame(maxWidth: notch.minX, alignment: .trailing)
#if DEBUG
				.border(.blue)
#endif
			}
			.frame(maxWidth: .infinity, maxHeight: NSScreen.builtIn?.notch?.height ?? 31.5)
			.padding(.horizontal)
			.background(.black)

			// Top Screen Corners

			Rectangle()
#if DEBUG
				.fill(.red)
#else
				.fill(.black)
#endif
				.frame(height: 10)
				.clipShape(InvertedBottomCorners(radius: 10))

			// Window View

			state.window?.view
				.background(.background)
				.roundedCorners(color: .gray.opacity(0.4))
				.shadow(color: .black, radius: 20)
				.transition(
					.blurReplace
						.animation(.default)
				)
//				.border(.red)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
#if DEBUG
				.border(.blue)
#endif
				.padding()
				// if inverted top corners
				.padding(.horizontal, 10)
				.padding(.bottom, 10)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.environment(\.colorScheme, .dark)
	}
}

#Preview {
	AppView()
}
