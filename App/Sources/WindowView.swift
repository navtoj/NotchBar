import LaunchAtLogin
import SwiftUI

struct WindowView: View {
	var body: some View {
		VStack {
			LaunchAtLogin.Toggle("Open at Login")
		}
		.padding()
	}
}

#Preview {
	WindowView()
}
