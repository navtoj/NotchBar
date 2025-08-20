import SwiftUI

final class AppWindow: NSWindow {
	// MARK: Static Properties

	static let shared = AppWindow()

	// MARK: Properties

	private let hostingView = NSHostingView(rootView: ContentView())

	// MARK: Lifecycle

	private init() {
		super.init(
			contentRect: .zero,
			styleMask: [.titled, .closable, .miniaturizable, .resizable],
			backing: .buffered,
			defer: true
		)
		title = "NotchBar"
		contentView = hostingView
		setContentSize(hostingView.intrinsicContentSize)

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
}
