import SwiftUICore

extension Angle {

	// 0
	static var right: Angle {
		return .radians(.zero)
	}

	// 90
	static var bottom: Angle {
		return .radians(.pi / 2)
	}

	// 180
	static var left: Angle {
		return .radians(.pi)
	}

	// 270
	static var top: Angle {
		return .radians(3 * .pi / 2)
	}
}
