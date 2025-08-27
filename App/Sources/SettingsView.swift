import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	var body: some View {
		VStack {
			LaunchAtLogin.Toggle("Open at Login")
		}
		.padding()
	}
}

#Preview {
	SettingsView()
}
