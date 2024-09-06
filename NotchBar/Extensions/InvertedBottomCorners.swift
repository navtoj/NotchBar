//
//  InvertedBottomCorners.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-05.
//

import SwiftUI

struct InvertedBottomCorners: Shape {
	var radius: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var p = Path()
		
		// Top Left
		p.move(to: CGPoint(x: rect.minX, y: rect.minY))
		
		// Top Right
		p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
		
		// Bottom Right
		p.addArc(
			center: CGPoint(x: rect.maxX - radius, y: rect.maxY),
			radius: radius,
			startAngle: .right,
			endAngle: .top,
			clockwise: true
		)
		
		// Botton Left
		p.addArc(
			center: CGPoint(x: rect.minX + radius, y: rect.maxY),
			radius: radius,
			startAngle: .top,
			endAngle: .left,
			clockwise: true
		)
		
		return p
	}
}

extension View {
	func invertedBottomCorners(background: Color, radius: CGFloat) -> some View {
		self
			.padding(.bottom, radius)
			.background(background)
			.clipShape(InvertedBottomCorners(radius: radius))
	}
}
