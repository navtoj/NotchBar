import SwiftUI

final class BarWindow: NSWindow {
	// MARK: Static Properties

	static let shared = BarWindow()

	// MARK: Properties

	private var observer: NSObjectProtocol?

	private let hostingView = NSHostingView(rootView: BarView())

	// MARK: Lifecycle

	deinit {
		if let observer {
			NotificationCenter.default.removeObserver(observer)
		}
	}

	private init() {
		super.init(
			contentRect: NSScreen.builtIn?.frame ?? .zero,
			styleMask: .borderless,
			backing: .buffered,
			defer: false
		)
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

	// MARK: Overridden Functions

	override func setFrame(_ frameRect: NSRect, display flag: Bool) {
		super.setFrame(NSScreen.builtIn?.frame ?? frameRect, display: flag)
	}

	// MARK: Functions

	private func handleShowHide() {
		guard let screen = NSScreen.builtIn else {
			AppState.shared.status = .noInternalScreen
			return orderOut(nil)
		}
		guard screen.notch != nil else {
			AppState.shared.status = .noNotchFound
			return orderOut(nil)
		}
		guard !screen.isMenuBarVisible else {
			AppState.shared.status = .hiddenUnderMenuBar
			return orderOut(nil)
		}

		AppState.shared.status = .none
		orderFrontRegardless()
	}
}
