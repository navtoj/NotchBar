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

// Command Helpers

@discardableResult
func appleScript(run command: String) -> NSAppleEventDescriptor? {
#if DEBUG
	print("appleScript:", command)
#endif
	var error: NSDictionary?
	guard let scriptObject = NSAppleScript(source: command) else { return nil }
	let output = scriptObject.executeAndReturnError(&error)
	if let error {
		print("AppleScript Error:", error)
	}
	return output
}

@discardableResult
func shellScript(run command: String) -> String {
#if DEBUG
	print("shellScript:", command)
#endif
	let process = Process()
	let pipe = Pipe()
	process.standardOutput = pipe
	process.standardError = pipe
	process.launchPath = "/bin/zsh"
	process.arguments = ["-c", command]
	do {
		try process.run()
	} catch {
		print("ShellScript Error:", error)
	}
	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let output = String(data: data, encoding: .utf8) ?? ""
	return output
}

// Debug Helpers

protocol PrinterAddResult {
	func print()
}
final class Printer: PrinterAddResult {
//	static var shared = Printer()
//	private init() {}

	private var keyLength: Int = 0
	private var outputs: [(String, Any?)] = []

	@discardableResult
	func add(_ key: String, _ value: Any? = nil) -> PrinterAddResult {
#if !DEBUG
		return self
#endif
		keyLength = max(keyLength, key.count)
		outputs.append((key, value))
		return self
	}

	func print() {
#if !DEBUG
		return
#endif
		let count = outputs.count { $0.1 != nil }
		for (key, value) in outputs {
			let text = count < 2 ? key : key.padding(toLength: keyLength, withPad: " ", startingAt: 0)
//			String(repeating: " ", count: keyLength - key.count)
			if let value {
				Swift.print(text, ":", value)
			} else {
				Swift.print(text)
			}
		}
		keyLength = 0
		outputs.removeAll()
	}
}
