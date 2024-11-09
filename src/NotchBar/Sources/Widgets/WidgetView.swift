import SwiftUI
import Defaults
import Pow

protocol PrimaryViewType: View {
	static var id: String { get }
}
protocol SecondaryViewType: View {}
extension Never: SecondaryViewType {}

struct WidgetView<Primary: PrimaryViewType, Secondary: SecondaryViewType>: View {
	let primary: (Binding<Bool>) -> Primary
	let secondary: ((Binding<Bool>) -> Secondary)?

	@State private var overlay: HorizontalAlignment

	// Default Values

	init(
		primary: @escaping (Binding<Bool>) -> Primary,
		secondary: ((Binding<Bool>) -> Secondary)? = nil,
		overlay: HorizontalAlignment = .center
	) {
		self.primary = primary
		self.secondary = secondary
		self.overlay = overlay
	}

	@Default(.widgetLayout) var layout

	@State private var hovering = false
	@State private var expand = false
	var body: some View {

		// Primary View

		primary($expand)
			.modifier(PrimaryLayout(layout: layout[Primary.id]))
			.contextMenu {
#if DEBUG
				Button("Debug Layout") {
					for (key, value) in layout {
						print(value, key)
					}
				}
				Button("Reset Layout") {
					layout = [:]
				}
#endif
				Menu("Alignment") {
					Button("Leading") {
						layout[Primary.id] = WidgetLayout.alignment(.leading, on: layout[Primary.id])
					}
					Button("Center") {
						layout[Primary.id] = WidgetLayout.alignment(.center, on: layout[Primary.id])
					}
					Button("Trailing") {
						layout[Primary.id] = WidgetLayout.alignment(.trailing, on: layout[Primary.id])
					}
#if DEBUG
					Button("Reset") {
						layout[Primary.id] = WidgetLayout.alignment(nil, on: layout[Primary.id])
					}
#endif
				}
			}
			.overlay(alignment: Alignment(horizontal: overlay, vertical: .bottom)) {
				VStack {
					if expand {

						// Secondary View

						secondary?($expand)
							.padding(.top, 3)
							.transition(.blurReplace.animation(.snappy(duration: 0.4)))
							.onFrameChange(in: .global) { frame in
								// FIXME: keep overlay within horizontal screen bounds

								// ignore if already aligned
								guard overlay == .center else { return }

								// get screen bounds
								let bounds = NSScreen.builtIn.frame

								// check if out of bounds
								if frame.minX < 0 {
									let offset = 0 - frame.minX
#if DEBUG
									print("offset.left", offset)
#endif
									overlay = .leading
								} else if frame.maxX > bounds.width {
									let offset = bounds.width - frame.maxX
#if DEBUG
									print("offset.right", offset)
#endif
									overlay = .trailing
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

private struct PrimaryLayout: ViewModifier {
	let layout: WidgetLayout?

	func body(content: Content) -> some View {
		if let alignment = layout?.alignment {
			content
#if DEBUG
				.border(.green)
#endif
				.frame(
					maxWidth: .infinity,
					alignment: .init(
						horizontal: alignment,
						vertical: .center
					)
				)
#if DEBUG
				.border(.yellow)
#endif
		} else {
			content
		}
	}
}
