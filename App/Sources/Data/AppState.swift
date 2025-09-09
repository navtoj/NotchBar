import AppKit

// MARK: - AppState

@Observable
final class AppState {
	// MARK: Static Properties

	static let shared = AppState()

	// MARK: Properties

	var status: Status? {
		didSet {
			AppStatus.shared.update(status)
		}
	}
}

// MARK: - Status

enum Status: String {
	case noInternalScreen = "No internal screen."
	case noNotchFound = "No notch found."
	case hiddenUnderMenuBar = "Hidden under Menu Bar."
}
