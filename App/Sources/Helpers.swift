import AppKit

#if DEBUG
	/// This is true when the `DEBUG` compilation condition is set, and false otherwise.
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
			} else if DEBUG {
				print(">", keyPath.description, change.newValue ?? "nil")
			}
		}
	))
}

// MARK: - Commands

@discardableResult
func appleScript(run command: String) -> AppleScript? {
	if DEBUG {
		print("appleScript:", command)
	}

	var error: NSDictionary?
	guard let scriptObject = NSAppleScript(source: command) else { return .none }

	let output = scriptObject.executeAndReturnError(&error)
	if let error {
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
func shellScript(run command: String) -> ShellScript {
	if DEBUG {
		print("shellScript:", command)
	}

	let process = Process()
	let pipe = Pipe()
	process.standardOutput = pipe
	process.standardError = pipe
	process.launchPath = "/bin/zsh"
	process.arguments = ["-c", command]

	do {
		try process.run()
	} catch {
		return .error(error)
	}

	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let output = String(data: data, encoding: .utf8)?
		.trimmingCharacters(in: .whitespacesAndNewlines)
	return .output(output ?? "")
}

// MARK: - ShellScript

enum ShellScript {
	case output(String)
	case error(Error)

	// MARK: Computed Properties

	var description: String {
		switch self {
			case let .output(value): value
			case let .error(value): value.localizedDescription
		}
	}
}
