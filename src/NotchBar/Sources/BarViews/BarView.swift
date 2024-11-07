import SwiftUI

struct BarView: View {
	let widgets: [BarLayoutView]

	var body: some View {
		if let notch = NSScreen.builtIn.notch {
			HStack(spacing: notch.width) {
				Group {
					Text("Left")
					Text("Left")
					Text("Left")
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("Left")
						.frame(maxWidth: .infinity, alignment: .trailing)
					Text("Left")
				}
				.modifier(BarArea(width: notch.minX, height: notch.height))

				Group {
					Text("Right")
					Text("Right")
					Text("Right")
					Text("Right")
					Text("Right")
				}
				.modifier(BarArea(width: notch.minX, height: notch.height))
			}
			.frame(
				maxWidth: NSScreen.builtIn.frame.width,
				maxHeight: notch.height
			)
			.padding(.horizontal)
			.background(.black)
			.environment(\.colorScheme, .dark)
		}
	}
}

#Preview {
	BarView(widgets: [])
}

private struct BarArea: ViewModifier {
	let width: CGFloat
	let height: CGFloat
	func body(content: Content) -> some View {
		HStack(/*spacing: 0*/) {
			content
		}
#if DEBUG
		.border(.red)
#endif
		.frame(maxWidth: width, maxHeight: height, alignment: .leading)
#if DEBUG
		.border(.yellow/*.opacity(0.5)*/)
#endif
		.clipped()
	}
}
