import SwiftUI

final class WrapperData: ObservableObject {
	@Published var expand: Bool

	init(expand: Bool = false) {
		self.expand = expand
	}
}

struct Wrapper<Primary: View, Secondary: View>: View {
	let id = UUID()
	private let primary: Primary
	private let secondary: Secondary?

	init(primary: Primary) where Secondary == Never {
		self.primary = primary
		self.secondary = nil
	}
	init(
		primary: Primary,
		secondary: Secondary
	) {
		self.primary = primary
		self.secondary = secondary
	}

	@StateObject private var data = WrapperData()
	var body: some View {
		primary
			.environmentObject(data)
			.overlay(alignment: .bottom) {
				VStack(spacing: 0) {
					if data.expand {
						secondary
							.environmentObject(data)
					}
				}
				.alignmentGuide(.bottom) { dim in dim[.top] }
			}
	}
}

#Preview {
	Wrapper(primary: Subview(), secondary: Subview())
}

struct Subview: View {
	@EnvironmentObject private var data: WrapperData

	var body: some View {
		Toggle(isOn: $data.expand, label: {
			Text("Subview")
		})
	}
}
