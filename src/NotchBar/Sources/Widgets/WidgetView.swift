import SwiftUI
import Pow

struct WidgetView<Primary: View, Secondary: View>: View {
	let primary: (Binding<Bool>) -> Primary
	let secondary: ((Binding<Bool>) -> Secondary)?

	// Default Values

	init(
		primary: @escaping (Binding<Bool>) -> Primary,
		secondary: ((Binding<Bool>) -> Secondary)? = nil,
		overlay alignment: HorizontalAlignment = .center
	) {
		self.primary = primary
		self.secondary = secondary
		self.alignment = alignment
	}

	@State private var alignment: HorizontalAlignment
	@State private var expand = false

	@State private var hovering = false
	var body: some View {
		VStack {

			// Primary View

			primary($expand)
		}
		.frame(maxHeight: .infinity)
		.overlay(alignment: Alignment(horizontal: alignment, vertical: .bottom)) {
			VStack {
				if expand {

					// Secondary View

					secondary?($expand)
						.padding(.top, 3)
						.transition(.blurReplace.animation(.snappy(duration: 0.4)))
						.onFrameChange(in: .global) { frame in
							// FIXME: keep overlay within horizontal screen bounds

							// ignore if already aligned
							guard alignment == .center else { return }

							// get screen bounds
							let bounds = NSScreen.builtIn.frame

							// check if out of bounds
							if frame.minX < 0 {
								let offset = 0 - frame.minX
#if DEBUG
								print("offset.left", offset)
#endif
								alignment = .leading
							} else if frame.maxX > bounds.width {
								let offset = bounds.width - frame.maxX
#if DEBUG
								print("offset.right", offset)
#endif
								alignment = .trailing
							}
						}
				}
			}
			.alignmentGuide(.bottom) { dim in dim[.top] }
		}
		.onHover { hovering in
			Task { await handleHover(isHovering: hovering) }
		}
	}

	private func handleHover(isHovering: Bool) async {

		// update hover state
		hovering = isHovering

		// ignore if not expanded
		guard expand else { return }

		// delay to prevent closing on expand
		try? await Task.sleep(nanoseconds: 250_000_000) // 250 ms

		// close if not hovering
		if !hovering { expand = false }
	}
}

#Preview {
	WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
}
