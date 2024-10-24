import SwiftUI

struct ActiveAppSecondary: View {
	private let data = ActiveAppData.shared

	@Binding var expand: Bool

	@State private var size: CGSize = .zero
	@State private var sizeID: String = ""
	var body: some View {
		Group {
			if let items = data.menu {
				HStack(spacing: 0) {
					ForEach(items) { item in
						MenuItem(item: item)
							.padding(8)
						if item != items.last { Divider() }
					}
					// TODO: boxes under this view
				}
				.onSizeChange(sync: $size, check: (
					before: $sizeID,
					after: data.app?.bundleIdentifier ?? "id"
				))
			} else {
				HStack {
					Text("Accessibility Access Required")
					Button("Enable") { checkPermissions(prompt: true) }
				}
				.fixedSize()
				.padding(8)
				.onSizeChange(sync: $size, check: (
					before: $sizeID,
					after: data.app?.bundleIdentifier ?? "id" + ".permissions"
				))
				.onAppear { data.invalidate(.menu) }
			}
		}
		.frame(width: size.width)
		.background(.background)
		.roundedCorners(5, width: 4)
	}

	@ViewBuilder
	func MenuItem(item: MenuItem) -> some View {
		let leaf = Button("\(item.level). " + item.name) {
			print("Button", item.name, item.level)
		}

		let branch = Menu("\(item.level). " + item.name) {
			ForEach(item.submenu) { subitem in
				MenuItem(item: subitem)
			}
		}
			.menuIndicator(.hidden)
			.menuStyle(.button)
			.buttonStyle(.borderless)

		if item.submenu.isEmpty {
			AnyView(leaf)
		} else {
			AnyView(branch)
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	ActiveAppSecondary(expand: $expand)
}
