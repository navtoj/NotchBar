//
//  AnimatedNumbers.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-07.
//

import SwiftUI

extension View {
	func animatedNumbers(value: Double) -> some View {
		self
			.monospacedDigit()
			.contentTransition(.numericText(value: value))
			.animation(
				.spring(response: 0.3, dampingFraction: 0.8),
				value: value
			)
	}
}
