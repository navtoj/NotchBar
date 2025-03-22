import AppKit
import Defaults
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

	private(set) var card: WindowCard? = Defaults[.skipWelcome] ? nil : .welcome
	func showCard(_ card: WindowCard) {
		self.card = card
	}
	func hideCard() {
		card = nil
	}
	func toggleCard(_ card: WindowCard) {
		self.card = self.card == card ? nil : card
	}

	private(set) var todo: String = ""
	func setTodo(to value: String) {
		todo = value
	}

	// disallow direct instantiation

	private init() {}

	deinit {}
}
