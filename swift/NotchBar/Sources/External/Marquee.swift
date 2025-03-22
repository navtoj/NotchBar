//
//  Marquee.swift
//  https://github.com/nainamaharjan/MarqueeSwiftUI
//
//  Created by Naina Maharjan on 28/02/2024.
//

// TODO: Replace Package
// https://github.com/stonko1994/Marquee -> didn't work, find a better one

import SwiftUI

struct Marquee<Content: View>: View {
	@ViewBuilder var content: Content
	@State private var containerWidth: CGFloat? = nil
	@State private var model: MarqueeModel
	private var targetVelocity: Double
	private var spacing: CGFloat

	init(targetVelocity: Double, spacing: CGFloat = 10, @ViewBuilder content: () -> Content) {
		self.content = content()
		self._model = .init(wrappedValue: MarqueeModel(targetVelocity: targetVelocity, spacing: spacing))
		self.targetVelocity = targetVelocity
		self.spacing = spacing
	}

	var extraContentInstances: Int {
		let contentPlusSpacing = ((model.contentWidth ?? 0) + model.spacing)
		guard contentPlusSpacing != 0 else { return 1 }
		return Int(((containerWidth ?? 0) / contentPlusSpacing).rounded(.up))
	}

	var body: some View {
		TimelineView(.animation) { context in
			HStack(spacing: model.spacing) {
				HStack(spacing: model.spacing) {
					content
				}
				.measureWidth { model.contentWidth = $0 }
				ForEach(Array(0..<extraContentInstances), id: \.self) { _ in
					content
				}
			}
			.offset(x: model.offset)
			.fixedSize()
			.onChange(of: context.date, initial: false) { oldDate, newDate in
				DispatchQueue.main.async {
					model.tick(at: newDate)
				}
			}
		}
		.measureWidth { containerWidth = $0 }
		.gesture(dragGesture)
		.onAppear { model.previousTick = .now }
		.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
	}

	var dragGesture: some Gesture {
		DragGesture(minimumDistance: 0)
			.onChanged { value in
				model.dragChanged(value)
			}.onEnded { value in
				model.dragEnded(value)
			}
	}

	private func throttle(delay: Double, action: @escaping () -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			action()
		}
	}
}


struct MarqueeModel {
	var contentWidth: CGFloat? = nil
	var offset: CGFloat = 0
	var dragStartOffset: CGFloat? = nil
	var dragTranslation: CGFloat = 0
	var currentVelocity: CGFloat = 0

	var previousTick: Date = .now
	var targetVelocity: Double
	var spacing: CGFloat
	init(targetVelocity: Double, spacing: CGFloat) {
		self.targetVelocity = targetVelocity
		self.spacing = spacing
	}

	mutating func tick(at time: Date) {
		let delta = time.timeIntervalSince(previousTick)
		defer { previousTick = time }
		currentVelocity += (targetVelocity - currentVelocity) * delta * 3
		if let dragStartOffset {
			offset = dragStartOffset + dragTranslation
		} else {
			offset -= delta * currentVelocity
		}
		if let c = contentWidth {
			offset.formTruncatingRemainder(dividingBy: c + spacing)
			while offset > 0 {
				offset -= c + spacing
			}

		}
	}

	mutating func dragChanged(_ value: DragGesture.Value) {
		if dragStartOffset == nil {
			dragStartOffset = offset
		}
		dragTranslation = value.translation.width
	}

	mutating func dragEnded(_ value: DragGesture.Value) {
		offset = dragStartOffset! + value.translation.width
		dragStartOffset = nil
	}

}

extension View {
	func measureWidth(_ onChange: @escaping (CGFloat) -> ()) -> some View {
		background {
			GeometryReader { proxy in
				let width = proxy.size.width
				Color.clear
					.onChange(of: width, initial: false) { oldWidth, newWidth in
						// FIXME: onChange(of: CGFloat) action tried to update multiple times per frame.
						DispatchQueue.main.async {
							onChange(newWidth)
						}
					}
			}
		}
	}
}
