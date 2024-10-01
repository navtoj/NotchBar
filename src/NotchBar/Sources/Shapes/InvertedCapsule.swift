//
//  InvertedCapsule.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-30.
//

import SwiftUICore

struct InvertedCapsule: Shape {
	// _____
	// )   (
	// `````

	func path(in rect: CGRect) -> Path {
#if DEBUG
		print("InvertedCapsule", rect)
#endif
		var p = Path()

		// Top Left
		p.move(to: CGPoint(x: rect.minX, y: rect.minY))

		// Top Right
		p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

		// Bottom Right
		p.addArc(
			center: CGPoint(x: rect.maxX, y: rect.midY),
			radius: rect.midY,
			startAngle: .top,
			endAngle: .bottom,
			clockwise: true
		)

		// Botton Left
		p.addArc(
			center: CGPoint(x: rect.minX, y: rect.midY),
			radius: rect.midY,
			startAngle: .bottom,
			endAngle: .top,
			clockwise: true
		)

		return p
	}
}
