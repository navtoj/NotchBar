import SwiftUI

struct ActiveAppSecondary: View {
	private let data = ActiveAppData.shared

	@Binding var expand: Bool

	@State private var size: CGSize = .zero
	@State private var sizeID: String = ""
	var body: some View {
		VStack(spacing: 0) {
			if data.menu == nil {
				HStack {
					Text("Accessibility Access Required")
					Button("Enable") {
						_ = checkPermissions(prompt: true)
					}
				}
				.fixedSize()
				.padding(.vertical, 8)
				.onSizeChange(
					sync: $size,
					check: (
						before: $sizeID,
						after: data.app?.bundleIdentifier ?? "id" + ".permissions"
					)
				)
				.onAppear {
					data.invalidate(.menu)
				}
			} else if let items = data.menu {
				ForEach(items) { item in
					Text(item.name)
						.fixedSize()
						.padding(.vertical, 12)
						.onSizeChange(
							sync: $size,
							if: .max,
							check: (
								before: $sizeID,
								after: data.app?.bundleIdentifier ?? "id"
							)
						)
					if item != items.last {
						Divider()
							.padding(.horizontal, -4)
					}
				}
			}
		}
		.frame(maxWidth: size.width)
		.padding(.horizontal, 8)
		.background(.background)
		.roundedCorners(5, width: 4)
	}
}

#Preview {
	@Previewable @State var expand = true
	ActiveAppSecondary(expand: $expand)
}
