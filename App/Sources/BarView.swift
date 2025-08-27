import LaunchAtLogin
import SwiftUI

struct BarView: View {
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				Color.clear
			}
			.padding(.horizontal)
			.frame(
				maxWidth: .infinity,
				maxHeight: NSScreen.builtIn?.notch?.height ?? 31.5,
				alignment: .leading
			)
			.background(.black)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	BarView()
}
