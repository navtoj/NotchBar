import AppKit

@Observable final class ActiveAppData {
	static let shared = ActiveAppData()
	
	private(set) var activeApp = NSWorkspace.shared.frontmostApplication
	
	private init() {
		
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
		
		self.activeApp = app
	}
}
