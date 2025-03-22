import SwiftUI

struct PrimaryView: View {
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
			expand.toggle()
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	PrimaryView(expand: $expand)
}
