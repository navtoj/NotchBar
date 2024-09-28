import SwiftUI

struct AppView: View {

	let notchHeight = NSScreen.builtIn?.notch?.height ?? 31.5

	var body: some View {
		Group {
			HStack {
				Text("NotchBar")
					.background(.blue)
					.cornerRadius(10)
					.padding(.leading)
			}
			.frame(maxWidth: .infinity, maxHeight: notchHeight, alignment: .leading)
			.background(.green)
			// TODO: add inverted bottom corners view (based on preferences)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//		.background(.red)
		.preferredColorScheme(.dark)
	}
}

#Preview {
	AppView()
}
