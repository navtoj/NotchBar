import SwiftUI

final class BarWindow: NSWindow {
	// MARK: Static Properties

	static let shared = BarWindow()

	// MARK: Properties

	private var observer: NSObjectProtocol?

	private let hostingView = NSHostingView(rootView: BarView())

	// MARK: Lifecycle

	init() {
		super.init(
			contentRect: NSScreen.builtIn?.frame ?? .zero,
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
		title = "NotchBar"
		contentView = hostingView
		isReleasedWhenClosed = false
		animationBehavior = .none

		level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.normalWindow)) + 1)
		collectionBehavior = [
			.canJoinAllSpaces,
			.stationary,
			.fullScreenNone,
			.ignoresCycle,
		]
		backgroundColor = .clear
		isOpaque = false
		// hasShadow = true
		// ignoresMouseEvents = true
		isMovable = false
		// isMovableByWindowBackground = true

		handleShowHide()

		observer = NotificationCenter.default.addObserver(
			forName: NSApplication.didChangeScreenParametersNotification,
			object: nil,
			queue: .main
		) { _ in
			self.handleShowHide()
		}
	}

	deinit {
		if let observer {
			NotificationCenter.default.removeObserver(observer)
		}
	}

	// MARK: Overridden Functions

	override func setFrame(_ frameRect: NSRect, display flag: Bool) {
		super.setFrame(NSScreen.builtIn?.frame ?? frameRect, display: flag)
	}

	// MARK: Functions

	private func handleShowHide() {
		guard let screen = NSScreen.builtIn else {
			AppStatus.shared.setIcon(color: .disabledControlTextColor)
			AppStatus.shared.showInfo(title: "No internal screen.")
			return orderOut(nil)
		}
		guard screen.notch != nil else {
			AppStatus.shared.setIcon(color: .disabledControlTextColor)
			AppStatus.shared.showInfo(title: "No notch found.")
			return orderOut(nil)
		}
		guard !screen.isMenuBarVisible else {
			AppStatus.shared.setIcon(color: .disabledControlTextColor)
			AppStatus.shared.showInfo(title: "Hidden under Menu Bar.")
			return orderOut(nil)
		}

		AppStatus.shared.resetIcon()
		AppStatus.shared.hideInfo()
		orderFrontRegardless()
	}
}
