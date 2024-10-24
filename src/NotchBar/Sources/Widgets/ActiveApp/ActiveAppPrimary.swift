import SwiftUI

struct ActiveAppPrimary: View {
	private let data = ActiveAppData.shared

	@Binding var expand: Bool

	var body: some View {
		if let app = data.app {
			HStack {
				Text(app.localizedName ?? "Unknown")
					.id(app)
					.transition(.opacity.animation(.easeOut))
				if let icon = app.icon {
					Image(nsImage: icon)
						.resizable()
						.scaledToFit()
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
			.onTapGesture {
				expand.toggle()
			}
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	ActiveAppPrimary(expand: $expand)
}
