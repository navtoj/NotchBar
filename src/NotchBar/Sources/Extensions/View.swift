import SwiftUICore
import AppKit

private struct FramePreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero
	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
// https://fivestars.blog/articles/swiftui-share-layout-information/
struct FrameReader: ViewModifier {
	let coordinateSpace: CoordinateSpaceProtocol
	let action: (CGRect) -> Void

	func body(content: Content) -> some View {
		content
			.background {
				GeometryReader { proxy in
					Color.clear
						.preference(
							key: FramePreferenceKey.self,
							value: proxy.frame(in: coordinateSpace)
						)
				}
			}
			.onPreferenceChange(FramePreferenceKey.self, perform: action)
	}
}
extension View {
	func onFrameChange(in coordinateSpace: CoordinateSpaceProtocol = .local, perform action: @escaping (CGRect) -> Void) -> some View {
		modifier(FrameReader(coordinateSpace: coordinateSpace, action: action))
	}
}

struct SizeReader: ViewModifier {
	@Binding var size: CGSize

	func body(content: Content) -> some View {
		content
			.background {
				GeometryReader { proxy in
					Color.clear
						.onChange(of: proxy.size, initial: true) { old, new  in
#if DEBUG
//							print("size", old, "→", new)
#endif
							size = new
						}
				}
			}
	}
}
extension View {
	func onSizeChange(sync size: Binding<CGSize>) -> some View {
		modifier(SizeReader(size: size))
	}
}

struct RoundedCorners: ViewModifier {
	let radius: CGFloat
	let type: RoundedCornerStyle

	func body(content: Content) -> some View {
		content
			.clipShape(.rect(cornerRadius: radius, style: type))
	}
}
extension View {
	func roundedCorners(_ radius: CGFloat = 10, type: RoundedCornerStyle = .continuous) -> some View {
		modifier(RoundedCorners(radius: radius, type: type))
	}
}

struct RoundedBorder: ViewModifier {
	let radius: CGFloat
	let width: CGFloat
	let color: Color

	func body(content: Content) -> some View {
		content
			.roundedCorners(radius)
			.padding(width)
			.background(color)
			.roundedCorners(radius + width)
	}
}
extension View {
	func roundedBorder(radius: CGFloat = 10, width: CGFloat = 5, color: Color = .black) -> some View {
		modifier(RoundedBorder(radius: radius, width: width, color: color))
	}
}

struct AnimatedNumbers: ViewModifier {
	let value: Double

	func body(content: Content) -> some View {
		content
			.monospacedDigit()
			.contentTransition(.numericText(value: value))
			.animation(.default, value: value)
	}
}
extension View {
	func animatedNumbers(value: Double) -> some View {
		modifier(AnimatedNumbers(value: value))
	}
}
