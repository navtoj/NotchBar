import SwiftUI

// MARK: - SettingsWindow

final class SettingsWindow: NSWindow {
	// MARK: Static Properties

	static let shared = SettingsWindow()

	// MARK: Properties

	private let hostingView = NSHostingView(rootView: SettingsView())

	// MARK: Lifecycle

	private init() {
		super.init(
			contentRect: .zero,
			styleMask: [.titled, .closable, .miniaturizable],
			backing: .buffered,
			defer: true
		)
		title = "Settings"
		level = .floating
		contentView = hostingView
		setContentSize(hostingView.intrinsicContentSize)

		isReleasedWhenClosed = false
		delegate = self
		center()
	}

	// MARK: Overridden Functions

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		if event.type == .keyDown,
		   event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command,
		   event.charactersIgnoringModifiers == "w"
		{
			close()
			return true
		}

		return super.performKeyEquivalent(with: event)
	}

	// MARK: Functions

	@objc
	func open() {
		NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: .init()) { _, error in
			if let error { return print(error) }

			DispatchQueue.main.async {
				NSApp.setActivationPolicy(.regular)
				self.makeKeyAndOrderFront(nil)
			}
		}
	}
}

// MARK: NSWindowDelegate

extension SettingsWindow: NSWindowDelegate {
	#if DEBUG
		func windowDidBecomeMain(_: Notification) {
			if let path = Bundle.main.path(forResource: "Debug", ofType: "png", inDirectory: "Public/Icons"),
			   let image = NSImage(contentsOfFile: path)
			{
				NSApp.applicationIconImage = image
			}
		}
	#endif

	func windowWillClose(_: Notification) {
		NSApp.setActivationPolicy(.accessory)
	}
}
