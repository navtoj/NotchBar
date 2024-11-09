import SwiftUI
import Defaults

private struct AppWidgets {
	static let shared = AppWidgets()

	let widgets: [String] = [
		SystemInfoPrimary.id,
		MediaPrimary.id,
		TodoPrimary.id,
		ActiveAppPrimary.id,
	]

	private init() {}

	func name(of widget: String) -> String {
		widget
			.replacingOccurrences(of: "Primary", with: "")
			.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression)
	}
}

struct WidgetsLayout: View {
    var body: some View {
		VStack(spacing: 15) {
			ForEach(AppWidgets.shared.widgets, id: \.self) { widget in
				WidgetTile(widget: widget, side: .left)
			}

			HStack {
				VStack { Divider() }
				Text("Notch").fixedSize()
				VStack { Divider() }
			}
			.foregroundStyle(.gray)
#if DEBUG
			.onTapGesture {
				Defaults.reset(.widgetLayout)
				print("Defaults.widgetLayout reset.")
			}
#endif

			ForEach(AppWidgets.shared.widgets, id: \.self) { widget in
				WidgetTile(widget: widget, side: .right)
			}
		}
		.padding()
    }
}

struct WidgetTile: View {
	@Default(.widgetLayout) var layout

	let widget: String
	let side: BarArea

	@State private var isHovering = false
	var body: some View {
		if layout[widget]?.area == side {
			HStack(spacing: 30) {
				HStack() {
					Image(systemSymbol: (layout[widget]?.visible ?? false) ? .checkmark : .xmark)
						.contentTransition(.symbolEffect)
						.contentShape(.rect)
						.onTapGesture {
							let visible = layout[widget]?.visible ?? false
							layout[widget] = WidgetLayout.visible(!visible, on: layout[widget])
						}
					Text(AppWidgets.shared.name(of: widget))
						.fixedSize()
				}
				HStack(spacing: 15) {
					Image(systemSymbol: .arrowUp)
					Image(systemSymbol: .arrowDown)
				}
				.frame(maxWidth: .infinity, alignment: .trailing)
				.opacity(isHovering ? 1 : 0)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.onHover { hovering in
				isHovering = hovering
			}
		}
	}
}

#Preview {
    WidgetsLayout()
}
