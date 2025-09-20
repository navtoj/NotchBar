import Defaults
import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	var body: some View {
		VStack(alignment: .leading) {
			Text("Settings")
				.font(.title2)
				.bold()
			Group {
				LaunchAtLogin.Toggle("Open at Login")
				Defaults.Toggle("Rounded Corners", key: .roundCorners)
			}
			.font(.title3)

			if let status = AppState.shared.status {
				Divider()
					.padding(.vertical, 5)

				Text("Status")
					.font(.title2)
					.bold()
					.padding(.bottom, 2)

				Text(status.rawValue)
					.font(.title3)
					.padding(.bottom, 2)

				if status == .noNotchFound {
					HStack {
						Text("Automatically hide and show the menu bar")
							.frame(maxWidth: .infinity, alignment: .leading)
						Picker(
							"",
							selection: Binding(
								get: { SystemState.shared.menuBarAutoHide },
								set: { value in
									guard value != SystemState.shared.menuBarAutoHide else { return }

									let shellCommand = "defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -int"
									shellScript(run: "\(shellCommand) \(value.visibleInFullscreen ? 1 : 0)")

									let scriptCommand = "tell application \"System Events\" to set autohide menu bar of dock preferences to"
									let output = appleScript(run: "\(scriptCommand) \(value.hiddenOnDesktop)")

									if case let .error(data) = output,
									   data.value(forKey: "NSAppleScriptErrorNumber") as? Int == -1743,
									   let bundleId = Bundle.main.bundleIdentifier
									{
										shellScript(run: "tccutil reset AppleEvents \(bundleId)")
									}
								}
							)
						) {
							ForEach(MenuBarAutoHide.allCases) { item in
								Text(item.rawValue)
									.tag(item)
							}
						}
						.fixedSize()
					}
					.padding(.horizontal, 10)
					.frame(width: 458, height: 36)
					.background(.background)
					.cornerRadius(4.5, width: 0.5, color: .separatorColor)
				}
			}
		}
		.padding()
		.fixedSize()
	}
}

#Preview {
	SettingsView()
}
