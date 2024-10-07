import SwiftUICore

struct RoundCornersInvertedTop: Shape {
	// _______
	// )     (
	//  (   )
	//  `````

	func path(in rect: CGRect) -> Path {
		var p = Path()

		// Top Left
		p.addArc(
			center: CGPoint(x: rect.minX - radius, y: rect.minY + radius),
			radius: radius,
			startAngle: .top,
			endAngle: .right,
			clockwise: false
		)

		// Bottom Left
		p.addArc(
			center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
			radius: radius,
			startAngle: .left,
			endAngle: .bottom,
			clockwise: true
		)

		// Bottom Right
		p.addArc(
			center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
			radius: radius,
			startAngle: .bottom,
			endAngle: .right,
			clockwise: true
		)

		// Top Right
		p.addArc(
			center: CGPoint(x: rect.maxX + radius, y: rect.minY + radius),
			radius: radius,
			startAngle: .left,
			endAngle: .top,
			clockwise: false
		)

		return p
	}

	var radius: CGFloat = 10
}
