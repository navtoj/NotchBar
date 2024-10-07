import SwiftUI

struct PrimaryView: View {
	private let state = AppState.shared

	@Binding var expand: Bool

	@State private var symbolChange = false
	var body: some View {
		HStack {
			Text("Primary")
			Text("Primary")

			Image(systemSymbol: symbolChange ? .handTapFill : .handTap)
				.resizable()
				.scaledToFit()
				.fixedSize()
				.contentTransition(.symbolEffect)
				.onTapGesture {
#if DEBUG
					print("Tap Symbol")
#endif
					symbolChange.toggle()
				}
		}
		.padding(.vertical, 5)
		.padding(.horizontal, 10)
		.background(expand ? AnyShapeStyle(.background) : AnyShapeStyle(.clear))
		// pill shape
		.clipShape(.capsule(style: .continuous))
		// tappable
		.contentShape(.capsule(style: .continuous))
		.onTapGesture {
#if DEBUG
			print("Tap Primary")
#endif
			expand.toggle()
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	PrimaryView(expand: $expand)
}
