import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
	// MARK: Static Properties

	static let shared = AppDelegate()

	// MARK: Properties

	private let status = AppStatus.shared
	private let settings = SettingsWindow.shared
	private let bar = BarWindow.shared

	// MARK: Functions

	func applicationWillFinishLaunching(_: Notification) {
		// Single Instance

		if let id = Bundle.main.bundleIdentifier,
		   NSRunningApplication.runningApplications(withBundleIdentifier: id).count > 1
		{
			print("Another instance is already running.")
			NSApp.terminate(nil)
		}

		// Prevent Focus

		NSApp.setActivationPolicy(.prohibited)
	}

	func applicationShouldHandleReopen(_ app: NSApplication, hasVisibleWindows: Bool) -> Bool {
		// Alternative Settings Entry

		if app.windows
			.filter({ $0.title == "Settings" && $0.isVisible })
			.isEmpty
		{
			settings.open()
		}

		return hasVisibleWindows
	}

	func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
		!true
	}
}
