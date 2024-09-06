//
//  ViewInvertedBottomCorners.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-05.
//

import SwiftUI

struct InvertedBottomCorners: Shape {
	var radius: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var p = Path()
		
		// Botton Left
		p.addArc(
			center: CGPoint(x: rect.minX + radius, y: rect.maxY),
			radius: radius,
			startAngle: .left,
			endAngle: .top,
			clockwise: false
		)
		
		// Bottom Right
		p.addArc(
			center: CGPoint(x: rect.maxX - radius, y: rect.maxY),
			radius: radius,
			startAngle: .top,
			endAngle: .right,
			clockwise: false
		)
		
		// Top Right
		p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
		
		// Top Left
		p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
		
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
