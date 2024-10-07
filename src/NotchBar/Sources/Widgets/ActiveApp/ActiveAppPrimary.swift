import SwiftUI

struct ActiveAppPrimary: View {
	private let data = ActiveAppData.shared

	@Binding var expand: Bool

//	@State private var appName: CGSize = .zero
	var body: some View {
		if let app = data.activeApp {
			HStack {
				Text(app.localizedName ?? "Unknown")
					.id(app)
					.transition(.opacity.animation(.easeOut))
//					.onSizeChange(sync: $appName)
				if let icon = app.icon {
					Image(nsImage: icon)
						.resizable()
						.scaledToFit()
//						.frame(height: appName.height)
						.id(app)
						.transition(.opacity.animation(.easeOut))
				} else {
					Image(systemSymbol: .macwindow)
				}
			}
			.padding(.vertical, 4)
			.padding(.horizontal, 10)
			.background(.fill)
			.clipShape(.capsule(style: .continuous))
			.animation(.movingParts.overshoot, value: app)
			.padding(.bottom, 2)
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	ActiveAppPrimary(expand: $expand)
}
