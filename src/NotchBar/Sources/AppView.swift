import SwiftUI

struct AppView: View {

	@State var state = AppState.shared

	@State private var showSecondary = true

	var body: some View {

		// App View Container

		VStack(spacing: 0) {

			// Notch Bar

			HStack {

				// Widgets

				Text("Spacer")

				// TODO: keep overlay within screen bounds using alignment?

				WidgetView(alignment: .leading, showSecondary: $showSecondary)
					.onHover { hovering in
						print((hovering ? "+" : "-") + " WidgetView")
						if !hovering { showSecondary = false }
					}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal)
			.background(.black)
			.zIndex(1)
			.onTapGesture {
				print("Tap NotchBar")
			}
			.environment(\.colorScheme, .dark)

			// TODO: add as user preference?
			Rectangle()
				.fill(.black)
				.frame(height: 10)
				.clipShape(InvertedBottomCorners(radius: 10))

			// Window View

			Group {
				switch state.window {
					case .settings: Settings()
					case .welcome: Welcome()
					case .none: EmptyView()
				}
			}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	AppView()
}
