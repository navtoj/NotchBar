import SwiftUICore

extension View {

	func roundedCorners(_ by: CGFloat = 10, continuous: Bool = true) -> some View {
		clipShape(.rect(
			cornerRadius: by,
			style: continuous ? .continuous : .circular
		))
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
