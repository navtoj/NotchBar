import AppKit
import SwiftUICore

@Observable
final class AppState {

	// create singleton instance

	static let shared = AppState()

	// state properties

	enum WindowCard {
		case welcome
		case settings

		@ViewBuilder
		var view: some View {
			switch self {
				case .welcome: Welcome()
				case .settings: Settings()
			}
		}
	}

	private(set) var card: WindowCard? // = .settings
	func addCard(_ card: WindowCard) {
		self.card = card
	}
	func removeCard() {
		card = nil
	}
	func toggleCard(_ card: WindowCard) {
		self.card = self.card == card ? nil : card
	}

	// disallow direct instantiation

	private init() {}

	deinit {}
}
