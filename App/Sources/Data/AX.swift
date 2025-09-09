import AppKit
import AXSwift

@Observable
final class AX {
	// MARK: Static Properties

	static let shared = AX()

	// MARK: Properties

	private(set) var isTrusted: Bool = AXIsProcessTrusted()

	private var notifications: [NSObjectProtocol] = []

	private var queuedWork: DispatchWorkItem? {
		willSet {
			queuedWork?.cancel()
		}
		didSet {
			if let work = queuedWork {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: work)
			}
		}
	}

	// MARK: Lifecycle

	deinit {
		for observer in notifications {
			DistributedNotificationCenter.default().removeObserver(observer)
		}

		notifications.removeAll()
	}

	private init() {
		notifications.append(DistributedNotificationCenter.default().addObserver(
			forName: NSNotification.Name("com.apple.accessibility.api"),
			object: nil,
			queue: nil
		) { _ in
			self.queuedWork = DispatchWorkItem {
				self.isTrusted = AXIsProcessTrusted()
			}
		})
	}
}
