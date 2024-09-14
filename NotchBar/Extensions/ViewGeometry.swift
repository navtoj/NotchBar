//
//  ViewGeometry.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-13.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
  func geometryReader(onChange: @escaping (CGSize) -> Void) -> some View {
	background(
	  GeometryReader { geometryProxy in
		Color.clear
		  .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
	  }
	)
	.onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

/* Usage
 Text("Size")
 .geometryReader { size in
	 print("size", size)
 }
 */
