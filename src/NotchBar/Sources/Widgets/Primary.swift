//
//  Primary.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-30.
//

import SwiftUI

struct Primary: View {
	let state = AppState.shared

	@Binding var showSecondary: Bool
	@State private var symbolChange = false

	var body: some View {
		HStack {
			Text("Primary Primary Primary")
				.font(.system(size: 300))
				.minimumScaleFactor(0.01)

			Image(systemSymbol: symbolChange ? .handTapFill : .handTap)
				.resizable()
				.scaledToFit()
				.contentTransition(.symbolEffect)
				.onTapGesture {
					print("Tap Symbol")
					symbolChange.toggle()
				}
		}
		.padding(.vertical, 5)
		.padding(.horizontal, symbolChange ? 9.8 : 10)
		.background(showSecondary ? .blue : .clear)
		.pillShaped()
		.padding(.vertical, 3)
		.tappable()
		.onTapGesture {
			print("Tap Primary")
			showSecondary.toggle()
		}
	}
}

#Preview {
	@Previewable @State var showSecondary = true
	Primary(showSecondary: $showSecondary)
}
