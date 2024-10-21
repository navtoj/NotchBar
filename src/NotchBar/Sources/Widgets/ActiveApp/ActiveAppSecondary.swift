import SwiftUI

struct ActiveAppSecondary: View {
	private let data = ActiveAppData.shared

	@Binding var expand: Bool

	var body: some View {
		VStack(spacing: 8) {
			if let items = data.menu {
				ForEach(items) { item in
					Text(item.name)
						.fixedSize()
					if item != items.last {
						Divider()
					}
				}
			}
		}
		.padding(.vertical, 8)
		.padding(.horizontal, 4)
		.background(.background)
		.roundedCorners(5, width: 4)
	}
}

#Preview {
	@Previewable @State var expand = true
	ActiveAppSecondary(expand: $expand)
}
