//
//  WidgetView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-29.
//

import SwiftUI
import Pow

struct WidgetView<Primary: View, Secondary: View>: View {
	let alignment: HorizontalAlignment = .leading
	// TODO: keep overlay within screen bounds using alignment?

	let primary: (Binding<Bool>) -> Primary
	let secondary: ((Binding<Bool>) -> Secondary)?

	@State private var expand = false

	var body: some View {
		primary($expand)
			.frame(maxHeight: NSScreen.builtIn?.notch?.height ?? 31.5)
			.overlay(alignment: Alignment(
				horizontal: alignment,
				vertical: .bottom
			)) {
				Group {
					if expand {
						secondary?($expand)
							.roundedCorners(5)
							.padding(4)
							.background(.black)
							.roundedCorners()
							.padding(.top, 3)
							.tappable()
							.transition(.blurReplace.animation(.snappy(duration: 0.4)))
					}
				}
				.alignmentGuide(.bottom) { dim in dim[.top] }
			}
			.onHover { hovering in
				if !hovering { expand = false }
			}
	}
}

#Preview {
	WidgetView(primary: PrimaryView.init, secondary: SecondaryView.init)
}
