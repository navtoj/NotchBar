import Defaults
import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	var body: some View {
		VStack(alignment: .leading) {
			LaunchAtLogin.Toggle("Open at Login")
			Defaults.Toggle("Rounded Corners", key: .roundCorners)
		}
		.padding()
	}
}

#Preview {
	SettingsView()
}
