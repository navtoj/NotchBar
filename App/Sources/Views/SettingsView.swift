import Defaults
import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	var body: some View {
		VStack(alignment: .leading) {
			if let status = AppState.shared.status {
				VStack(alignment: .leading) {
					Text("Status")
						.font(.title2)
					Text(status.rawValue)
						.font(.title3)
				}
				Divider()
			}

			VStack(alignment: .leading) {
				LaunchAtLogin.Toggle("Open at Login")
				Defaults.Toggle("Rounded Corners", key: .roundCorners)
			}
			.font(.title3)
		}
		.padding()
		.fixedSize()
	}
}

#Preview {
	SettingsView()
}
