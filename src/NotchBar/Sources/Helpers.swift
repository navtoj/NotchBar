import AppKit
import SwiftUICore

// Observer Helpers

func addNotificationObserver(
	to observers: inout [NSObjectProtocol],
	for name: NSNotification.Name,
	action: ((Notification) -> Void)? = nil
) {
	observers.append(NotificationCenter.default.addObserver(
		forName: name,
		object: nil,
		queue: nil
	) { notification in
		if let run = action {
			run(notification)
		} else {
#if DEBUG
			print(">", notification.name.rawValue)
#endif
		}
	})
}

func addUserDefaultsObserver(
	to observers: inout [NSKeyValueObservation],
	for keyPath: KeyPath<UserDefaults, Bool>,
	action: ((UserDefaults, NSKeyValueObservedChange<Bool>) -> Void)? = nil
) {
	observers.append(UserDefaults.standard.observe(
		keyPath,
		options: [.initial, .new],
		changeHandler: { defaults, change in
			if let run = action {
				run(defaults, change)
			} else {
#if DEBUG
				print(">", keyPath.description, change.newValue ?? "nil")
#endif
			}
		}
	))
}
