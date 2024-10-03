//
//  PrimaryView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-30.
//

import SwiftUI

struct PrimaryView: View {
	let state = AppState.shared

	@Binding var expand: Bool

	@State private var symbolChange = false
	var body: some View {
		HStack {
			HStack {
				Text("Primary")
				Text("Primary")
				Text("Primary")
			}

			Image(systemSymbol: symbolChange ? .handTapFill : .handTap)
				.resizable()
				.scaledToFit()
				.fixedSize()
				.contentTransition(.symbolEffect)
				.onTapGesture {
					print("Tap Symbol")
					symbolChange.toggle()
				}
		}
		.padding(.vertical, 5)
		.padding(.horizontal, 10)
		.background(expand ? AnyShapeStyle(.background) : AnyShapeStyle(.clear))
		.pillShaped()
		.padding(.vertical, 3)
		.tappable()
		.onTapGesture {
			print("Tap Primary")
			expand.toggle()
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	PrimaryView(expand: $expand)
}
