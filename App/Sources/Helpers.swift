import AppKit

#if DEBUG
	/// A Boolean value indicating whether the app is running in debug mode.
	public let DEBUG = true
#else
	public let DEBUG = false
#endif

// MARK: - Observers

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

// MARK: - Commands

@discardableResult
func appleScript(run command: String) -> AppleScript? {
	#if DEBUG
		print("appleScript:", command)
	#endif
	var error: NSDictionary?
	guard let scriptObject = NSAppleScript(source: command) else { return .none }

	let output = scriptObject.executeAndReturnError(&error)
	if let error {
		#if DEBUG
			print(error)
		#endif
		return .error(error)
	} else {
		return .output(output)
	}
}

// MARK: - AppleScript

enum AppleScript {
	case output(NSAppleEventDescriptor)
	case error(NSDictionary)

	// MARK: Computed Properties

	var description: String {
		switch self {
			case let .output(value): value.stringValue ?? value.description
			case let .error(value): value.description
		}
	}
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
	#if DEBUG
		print(output)
	#endif
	return output
}
