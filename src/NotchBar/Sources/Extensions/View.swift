//
//  View.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-30.
//

import SwiftUICore

extension View {

	func tappable() -> some View {
		contentShape(.rect)
	}

	func roundedCorners(_ by: CGFloat = 10, continuous: Bool = true) -> some View {
		clipShape(
			.rect(
				cornerRadius: by,
				style: continuous ? .continuous : .circular
			)
		)
	}

	func pillShaped() -> some View {
		clipShape(.capsule(style: .continuous))
	}

	func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
		background(
			GeometryReader { geometryProxy in
				Color.clear
					.preference(key: SizePreferenceKey.self, value: geometryProxy.size)
			}
		)
		.onPreferenceChange(SizePreferenceKey.self, perform: onChange)
	}
}

private struct SizePreferenceKey: PreferenceKey {
	static var defaultValue: CGSize = .zero
	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

/*
 Example: https://fivestars.blog/articles/swiftui-share-layout-information/

 var body: some View {
	 childView
		 .readSize { newSize in
			print("The new child size is: \(newSize)")
		 }
 }
 */
