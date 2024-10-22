import AppKit

@Observable final class ActiveAppData {
	static let shared = ActiveAppData()
	
	private(set) var app: NSRunningApplication?
	private(set) var menu: [MenuItem]?

	private init() {

		// Initial Values

		invalidate(.app)
		invalidate(.menu)

		// Track Active App
		
		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(handleDidActivateApplicationNotification),
			name: NSWorkspace.didActivateApplicationNotification,
			object: nil
		)
	}
	
	deinit {
		
		// Remove Active App Observer
		
		NSWorkspace.shared.notificationCenter.removeObserver(self)
	}
	
	@objc private func handleDidActivateApplicationNotification(_ notification: Notification) {
		
		guard let userInfo = notification.userInfo else {
			return print("Failed to get active app notification.")
		}
		
		guard let app = userInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
			return print("Failed to get NSRunningApplication.")
		}
		
		self.app = app
		self.menu = getMenu(of: app)
	}

	enum Invalidation {
		case app
		case menu
	}
	func invalidate(_ type: Invalidation) {
//		print("Invalidating...", type)

		if type == .app {
			app = NSWorkspace.shared.frontmostApplication
		}

		if type == .menu,
		   let app = app {
			menu = getMenu(of: app)
		}
	}
}
