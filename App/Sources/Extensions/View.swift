import SwiftUI

// https://lukaspistrol.com/blog/swiftui-bring-back-corner-radius

extension View {
	func cornerRadius(_ radius: CGFloat = 10, type: RoundedCornerStyle = .continuous) -> some View {
		modifier(RoundedCorners(radius: radius, type: type))
	}

	func cornerRadius(
		_ radius: CGFloat = 10,
		type: RoundedCornerStyle = .continuous,
		width: CGFloat = 1,
		color: Color = .black
	) -> some View {
		modifier(RoundedBorder(radius: radius, type: type, width: width, color: color))
	}
}

private struct RoundedCorners: ViewModifier {
	// MARK: Properties

	let radius: CGFloat
	let type: RoundedCornerStyle

	// MARK: Content Methods

	func body(content: Content) -> some View {
		content
			.clipShape(.rect(cornerRadius: radius, style: type))
	}
}

private struct RoundedBorder: ViewModifier {
	// MARK: Properties

	let radius: CGFloat
	let type: RoundedCornerStyle
	let width: CGFloat
	let color: Color

	// MARK: Content Methods

	func body(content: Content) -> some View {
		content
			.cornerRadius(radius, type: type)
			.overlay {
				RoundedRectangle(cornerRadius: radius, style: type)
					.stroke(color, lineWidth: width)
			}
	}
}
