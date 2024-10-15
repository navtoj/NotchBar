import SwiftUI

struct SecondaryView: View {
	@Binding var expand: Bool

	var body: some View {
		HStack {
			Text("Secondary View")
			Text("Secondary View")
			Text("Secondary View")
			Text("Secondary View")
			Text("Secondary View")
		}
		.fixedSize()
		.padding(5)
		.background(.background)
		.onTapGesture {
			AppState.shared.toggleCard(.settings)
			expand = false
		}
		.roundedCorners(5, width: 4)
	}
}

#Preview {
	@Previewable @State var expand = true
	SecondaryView(expand: $expand)
}
