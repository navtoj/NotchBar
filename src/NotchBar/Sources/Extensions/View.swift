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

enum SizeConstraint {
	case min
	case max
}
struct SizeReader: ViewModifier {
	@Binding var size: CGSize
	fileprivate let condition: SizeConstraint?

	func body(content: Content) -> some View {
		content
			.background {
				GeometryReader { proxy in
					Color.clear
						.onChange(of: proxy.size, initial: true) { old, new  in
//							print("size", old, "→", new)
							switch condition {
								case .min:
									size = CGSize(
										width: min(size.width, new.width),
										height: min(size.height, new.height)
									)
								case .max:
									size = CGSize(
										width: max(size.width, new.width),
										height: max(size.height, new.height)
									)
								case nil:
									size = new
							}
						}
				}
			}
	}
}
extension View {
	func onSizeChange(sync size: Binding<CGSize>, if condition: SizeConstraint? = .none) -> some View {
		modifier(SizeReader(size: size, condition: condition))
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
struct RoundedBorder: ViewModifier {
	let radius: CGFloat
	let type: RoundedCornerStyle
	let width: CGFloat
	let color: Color

	func body(content: Content) -> some View {
		content
			.roundedCorners(radius, type: type)
			.padding(width)
			.background(color)
			.roundedCorners(radius + width, type: type)
	}
}
extension View {
	func roundedCorners(_ radius: CGFloat = 10, type: RoundedCornerStyle = .continuous) -> some View {
		modifier(RoundedCorners(radius: radius, type: type))
	}
	func roundedCorners(
		_ radius: CGFloat = 10,
		type: RoundedCornerStyle = .continuous,
		width: CGFloat = 1,
		color: Color = .black
	) -> some View {
		modifier(RoundedBorder(radius: radius, type: type, width: width, color: color)
		)
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
