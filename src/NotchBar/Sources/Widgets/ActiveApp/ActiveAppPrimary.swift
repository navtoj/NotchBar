import SwiftUI

struct ActiveAppPrimary: View {
	private let data = ActiveAppData.shared

	@Binding var expand: Bool

	@State private var appName: CGSize = .zero
	var body: some View {
		if let app = data.activeApp {
			HStack {
				if let icon = app.icon {
					Image(nsImage: icon)
						.resizable()
						.scaledToFit()
						.frame(height: appName.height)
						.id(app)
						.transition(.opacity.animation(.easeOut))
				} else {
					Image(systemSymbol: .macwindow)
				}
				Text(app.localizedName ?? "Unknown")
					.id(app)
					.transition(.opacity.animation(.easeOut))
					.onSizeChange(sync: $appName)
			}
			.padding(.vertical, 5)
			.padding(.horizontal, 10)
			.background(.fill)
			.clipShape(.capsule(style: .continuous))
			.animation(.movingParts.overshoot, value: app)
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	ActiveAppPrimary(expand: $expand)
}
