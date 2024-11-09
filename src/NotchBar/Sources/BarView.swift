import SwiftUI
import Defaults

struct BarView: View {
	var body: some View {
		if let notch = NSScreen.builtIn.notch {
			HStack(spacing: notch.width) {
				HStack {
					WidgetView<SystemInfoPrimary, Never>(primary: SystemInfoPrimary.init)
				}
				.modifier(
					BarAreaFrame(
						width: notch.minX,
						height: notch.height,
						alignment: .leading
					)
				)

				HStack {
					WidgetView(
						primary: MediaPrimary.init,
						secondary: MediaSecondary.init,
						overlay: .leading
					)
					WidgetView<TodoPrimary, Never>(primary: TodoPrimary.init)
					WidgetView<ActiveAppPrimary, Never>(primary: ActiveAppPrimary.init)
				}
				.modifier(BarAreaFrame(width: notch.minX, height: notch.height, alignment: .trailing))
			}
			.frame(
				maxWidth: NSScreen.builtIn.frame.width,
				maxHeight: notch.height
			)
			.padding(.horizontal)
			.background(.black)
			.environment(\.colorScheme, .dark)
//			.zIndex(1)
		}
	}
}

#Preview {
	BarView()
}

private struct BarAreaFrame: ViewModifier {
	let width: CGFloat
	let height: CGFloat
	let alignment: HorizontalAlignment

	func body(content: Content) -> some View {
		content
//			.border(.red)
			.frame(
				maxWidth: width,
				maxHeight: height,
				alignment: .init(horizontal: alignment, vertical: .center)
			)
//			.border(.blue/*.opacity(0.5)*/)
			.clipped()
	}
}
