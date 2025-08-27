import SwiftUICore

struct InvertedBottomCorners: Shape {
	// MARK: Properties

	var radius: CGFloat

	// MARK: Functions

	// _______
	// |/   \|
	//

	func path(in rect: CGRect) -> Path {
		var line = Path()

		// Top Left
		line.move(to: CGPoint(x: rect.minX, y: rect.minY))

		// Top Right
		line.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

		// Bottom Right
		line.addArc(
			center: CGPoint(x: rect.maxX - radius, y: rect.maxY),
			radius: radius,
			startAngle: .right,
			endAngle: .top,
			clockwise: true
		)

		// Botton Left
		line.addArc(
			center: CGPoint(x: rect.minX + radius, y: rect.maxY),
			radius: radius,
			startAngle: .top,
			endAngle: .left,
			clockwise: true
		)

		return line
	}
}
