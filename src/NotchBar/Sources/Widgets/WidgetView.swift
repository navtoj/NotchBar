//
//  WidgetView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-29.
//

import SwiftUI
import Pow

struct WidgetView: View {
	static let primaryHeight: CGFloat = NSScreen.builtIn?.notch?.height ?? 31.5
	@State private var isAnimating = false

	let alignment: HorizontalAlignment
	@Binding var showSecondary: Bool

	@State var primarySize: CGSize = .zero
	@State var secondarySize: CGSize = .zero

	var body: some View {
		Primary(showSecondary: $showSecondary)
			.readSize { size in
				print("Primary", size)
				primarySize = size
			}
			.frame(maxHeight: WidgetView.primaryHeight)
			.overlay(alignment: Alignment(
				horizontal: alignment,
				vertical: .bottom
			)) {
				VStack {
					if showSecondary {
						VStack(alignment: alignment, spacing: 0) {

							// Connector

							Rectangle()
								.fill(.black)
								.frame(
									width: min(
										primarySize.width,
										secondarySize.width
									).rounded(.towardZero),
									// FIXME: thin gaps at edge of connector
									height: 3
								)
								.clipShape(InvertedCapsule())

								// align connector horizontally to Primary

								.alignmentGuide(alignment) { dim in
									dim[alignment] + alignment.offsetConnector()
								}

							// Main Overlay

							Secondary(show: $showSecondary)
								.readSize { size in
									print("Secondary", size)
									secondarySize = size
								}
								.roundedCorners(5)
								.padding(4)
								.background(.black)
								.roundedCorners()
						}
						.transition(
							.movingParts.wipe(edge: .top, blurRadius: 50)
							.animation(.default) // .delay(0.5)
						)
					}
				}

				// align top of overlay to bottom of Primary

				.alignmentGuide(.bottom) { dim in dim[.top] }

				// align overlay horizontally to Primary

				.alignmentGuide(alignment) { dim in
					dim[alignment] + alignment.offsetOverlay()
				}
			}
	}
}

#Preview {
	@Previewable let overlayAlignment: HorizontalAlignment = .leading
	@Previewable @State var showSecondary: Bool = true
	WidgetView(
		alignment: overlayAlignment,
		showSecondary: $showSecondary
	)
}

private extension HorizontalAlignment {
	func offsetOverlay(by amount: CGFloat = 10) -> CGFloat {
		switch self {
			case .leading: amount
			case .trailing: 0 - amount
			default: 0
		}
	}
	func offsetConnector(by amount: CGFloat = 10) -> CGFloat {
		switch self {
			case .leading: 0 - amount
			case .trailing: amount
			default: 0
		}
	}
}
