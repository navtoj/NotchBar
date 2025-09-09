import AXSwift
import Defaults
import LaunchAtLogin
import SwiftUI

// MARK: - BarView

struct BarView: View {
	// MARK: Properties

	@Default(.roundCorners) var roundCorners

	let color = Color.black

	// MARK: Content Properties

	var body: some View {
		VStack(spacing: 0) {
			HStack {}
				.padding(.horizontal)
				.frame(
					maxWidth: .infinity,
					maxHeight: NSScreen.builtIn?.notch?.height,
					alignment: .leading
				)
				.background(color)
			if roundCorners {
				Rectangle()
					.fill(color)
					.frame(height: 10)
					.clipShape(InvertedBottomCorners(radius: 10))
			}
			if DEBUG {
				VStack {
					if let bundle = Bundle.main.bundleIdentifier {
						Text("Bundle ID: \(bundle)")
					}
					if !AX.shared.isTrusted {
						Button("Enable Accessibility Access") { checkIsProcessTrusted(prompt: true) }
					}
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
									   let bundle = Bundle.main.bundleIdentifier
									{
										shellScript(run: "tccutil reset AppleEvents \(bundle)")
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
					.background(Color(
						NSColor(hex: "#2C2C2C")?.cgColor
							?? NSColor.windowBackgroundColor.cgColor)
					)
					.cornerRadius(4.5, width: 0.5, color: Color(
						NSColor(hex: "#4B4B4B")?.cgColor
							?? NSColor.separatorColor.cgColor
					))
				}
				.padding()
				.background()
				.cornerRadius()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	BarView()
}
