//
//  WidgetView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-29.
//

import SwiftUI
import Pow

struct WidgetView<Primary: View, Secondary: View>: View {
	let primary: (Binding<Bool>) -> Primary
	let secondary: ((Binding<Bool>) -> Secondary)?

	@State private var expand = false
	@State private var xAlignment: HorizontalAlignment = .center

	var body: some View {
		primary($expand)
			.overlay(alignment: Alignment(horizontal: xAlignment, vertical: .bottom)) {
				VStack(spacing: 0) {
					if expand {
						secondary?($expand)
							.roundedCorners(5)
							.padding(4)
							.background(.black)
							.roundedCorners(9)
							.padding(.top, 5)
							.contentShape(.rect)
							.transition(.blurReplace.animation(.snappy(duration: 0.4)))
							.background {

								// FIXME: keep overlay within horizontal screen bounds

								GeometryReader { geometry in
									Color.clear
										.onAppear {
											guard let bounds = NSScreen.builtIn?.frame else { fatalError("Built-in screen not found.") }

											// ignore if already aligned
											guard xAlignment == .center else { return }

											let frame = geometry.frame(in: .global)
											if frame.minX < 0 {
												print("offset", 0 - frame.minX)
												xAlignment = .leading
											} else if frame.maxX > bounds.width {
												print("offset", bounds.width - frame.maxX)
												xAlignment = .trailing
											}
										}
								}
							}
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
