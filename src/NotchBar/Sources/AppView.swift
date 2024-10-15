import SwiftUI

// TODO: hide when under menu bar

struct AppView: View {
	var body: some View {

		// App Container

		VStack(spacing: 0) {

			// Notch Bar

			if SystemState.shared.isMenuBarHidden,
			   let notch = NSScreen.builtIn.notch {
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
				.frame(maxWidth: .infinity, maxHeight: NSScreen.builtIn.notch?.height ?? 31.5)
				.padding(.horizontal)
				.background(.black)
				.environment(\.colorScheme, .dark)
				.zIndex(1) // above window card

				// Top Screen Corners

				Rectangle()
#if DEBUG
					.fill(.red)
#else
					.fill(.black)
#endif
					.frame(height: 10)
					.clipShape(InvertedBottomCorners(radius: 10))
			}

			// Window Card

			AppState.shared.card?.view
				.background(.background)
				.roundedCorners(color: .gray.opacity(0.4))
				.modifier(DynamicCardShadow())
				.transition(
					.blurReplace
						.animation(.default)
				)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
#if DEBUG
				.border(.blue)
#endif
				.padding()
				// TODO: only if inverted top corners
				.padding(.horizontal, 10)
				.padding(.bottom, 10)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	AppView()
}

private struct DynamicCardShadow: ViewModifier {
	@Environment(\.colorScheme) var colorScheme
	func body(content: Content) -> some View {
		if colorScheme == .dark {
			content.shadow(color: .black.opacity(1 - 0.33), radius: 20)
		} else {
			content.shadow(radius: 20)
		}
	}
}
