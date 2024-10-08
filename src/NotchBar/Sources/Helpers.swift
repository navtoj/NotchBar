import AppKit
import SwiftUICore

// Observer Helpers

func addNotificationObserver(
	to observers: inout [NSObjectProtocol],
	for name: NSNotification.Name,
	action: @escaping (Notification) -> Void = { _ in }
) {
	observers.append(NotificationCenter.default.addObserver(
		forName: name,
		object: nil,
		queue: nil
	) { notification in
#if DEBUG
		print(">", notification.name.rawValue)
#endif
		action(notification)
	})
}

func addUserDefaultsObserver(
	to observers: inout [NSKeyValueObservation],
	for keyPath: KeyPath<UserDefaults, Bool>,
	action: @escaping (UserDefaults, NSKeyValueObservedChange<Bool>) -> Void = { _, _ in }
) {
	observers.append(UserDefaults.standard.observe(
		keyPath,
		options: [.initial, .new],
		changeHandler: { defaults, change in
#if DEBUG
			print(">", keyPath.description, change.newValue ?? "nil")
#endif
			action(defaults, change)
		}
	))
}
