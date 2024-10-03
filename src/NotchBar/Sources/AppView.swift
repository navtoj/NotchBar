import SwiftUI

struct AppView: View {

	@State var state = AppState.shared

	var body: some View {

		// App Container

		VStack(spacing: 0) {

			// Notch Bar

			HStack {

				// Widgets

				WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal)
			.background(.black)
			.zIndex(1)
			.environment(\.colorScheme, .dark)

			// Fake Round Corners

			Rectangle()
				.fill(.black)
				.frame(height: 10)
				.clipShape(InvertedBottomCorners(radius: 10))
			// TODO: make optional?

			// Window View

			VStack(spacing: 0) {
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
