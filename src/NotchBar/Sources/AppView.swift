import SwiftUI

// TODO: hide when under menu bar

struct AppView: View {

	@State var size: CGSize = .zero

	var body: some View {

		// App Container

		VStack(spacing: 0) {

			// Notch Bar

			if SystemState.shared.isMenuBarHidden {
				BarView(widgets: [
					BarLayoutView()
				])

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
			if SystemState.shared.isMenuBarHidden,
			   let notch = NSScreen.builtIn.notch {
				HStack(spacing: notch.width) {
					// TODO: keep widgets within bounds w/ ViewThatFits?

					// Widgets - Left

					HStack {
						WidgetView<SystemInfoPrimary, Never>(primary: SystemInfoPrimary.init)
					}
					.border(.red)
					.frame(maxWidth: notch.minX, alignment: .leading)
					.border(.blue)

					// Widgets - Right

					HStack {
						WidgetView(
							primary: MediaPrimary.init,
							secondary: MediaSecondary.init,
							overlay: .leading
						)
						HStack {

							// Todo Widget Override

							if !AppState.shared.todo.isEmpty {
								Text(AppState.shared.todo)
									.lineLimit(1)
							} else {
								WidgetView<ActiveAppPrimary, Never>(primary: ActiveAppPrimary.init)
							}
						}
						.border(.green)
						.frame(maxWidth: .infinity, alignment: .trailing)
						.border(.yellow)
					}
					.border(.red)
					.frame(maxWidth: notch.minX, alignment: .leading)
					.border(.blue)
				}
				.frame(maxWidth: .infinity, maxHeight: NSScreen.builtIn.notch?.height ?? 31.5)
				.padding(.horizontal)
				.background(.black)
				.environment(\.colorScheme, .dark)
				.zIndex(1) // above window card
				.opacity(0.25)
			}

			// Window Card

			Group {

				// Notch Requirement Override

				if NSScreen.builtIn.notch == nil {
					HStack {
						HStack(spacing: 0) {
							Text("NotchBar")
								.bold()
							Text(" requires a screen with a notch.")
						}
						Button("Quit App", role: .destructive) {
							NSApp.terminate(self)
						}
					}
					.padding()
				} else if !SystemState.shared.isMenuBarHidden {

					// Menu Bar Hidden Override

					VStack {
						HStack {
							HStack(spacing: 0) {
								Text("NotchBar")
									.bold()
								Text(" is hidden under the macOS menu bar.")
									.frame(maxWidth: .infinity, alignment: .leading)
							}
							Button("Change Setting", role: .destructive) {
								if let url = URL(string: "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension") {
									NSWorkspace.shared.open(url)
								}
							}
						}
						.frame(maxWidth: size.width)
						HStack {
							Text("Automatically hide and show the menu bar")
								.frame(maxWidth: .infinity, alignment: .leading)
							HStack(spacing: 4) {
								Text(SystemState.shared.menuBarAutoHide.rawValue)
								Image(systemSymbol: .chevronUpChevronDown)
									.padding(2)
									.background(.quaternary.opacity(0.6))
									.roundedCorners(4)
							}
						}
						.padding(.horizontal, 10)
						.frame(width: 458, height: 36)
						.background(.quinary)
						.roundedCorners()
						.onSizeChange(sync: $size)
					}
					.padding()
				} else {
					AppState.shared.card?.view
				}
			}
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
