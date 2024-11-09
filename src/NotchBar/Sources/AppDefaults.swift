import Defaults
import SwiftUICore

extension Defaults.Keys {
	static let skipWelcome = Key<Bool>("skipWelcome", default: false)
	static let todoWidget = Key<String>("todoWidget", default: "")
	static let widgetLayout = Key<[String: WidgetLayout]>("widgetLayout",
		default: [
			SystemInfoPrimary.id: .init(visible: true, area: .left, position: 1),
			MediaPrimary.id: .init(visible: true, area: .right, position: 1, alignment: .leading),
			TodoPrimary.id: .init(visible: true, area: .right, position: 2),
			ActiveAppPrimary.id: .init(visible: true, area: .right, position: 3)
		]
	)
}

enum BarArea: String {
	case left
	case right
}
struct WidgetLayout {
	let visible: Bool
	let area: BarArea?
	let position: Int?
	let alignment: HorizontalAlignment?

	init(
		visible: Bool? = false,
		area: BarArea?,
		position: Int?,
		alignment: HorizontalAlignment? = .none
	) {
		self.visible = visible ?? false
		self.area = area
		self.position = position
		self.alignment = alignment
	}

	static func visible(_ visible: Bool, on layout: WidgetLayout? = nil) -> WidgetLayout {
		WidgetLayout(
			visible: visible,
			area: layout?.area,
			position: layout?.position,
			alignment: layout?.alignment
		)
	}
	static func area(_ area: BarArea?, on layout: WidgetLayout? = nil) -> WidgetLayout {
		WidgetLayout(
			visible: layout?.visible,
			area: area,
			position: layout?.position,
			alignment: layout?.alignment
		)
	}
	static func position(_ position: Int?, on layout: WidgetLayout? = nil) -> WidgetLayout {
		WidgetLayout(
			visible: layout?.visible,
			area: layout?.area,
			position: position,
			alignment: layout?.alignment
		)
	}
	static func alignment(_ alignment: HorizontalAlignment?, on layout: WidgetLayout? = nil) -> WidgetLayout {
		WidgetLayout(
			visible: layout?.visible,
			area: layout?.area,
			position: layout?.position,
			alignment: alignment
		)
	}
}
struct WidgetLayoutBridge: Defaults.Bridge {
	typealias Value = WidgetLayout
	typealias Serializable = [String: String]

	public func serialize(_ value: Value?) -> Serializable? {
		guard let value else { return nil }
		var object: [String: String] = [:]

		object["visible"] = value.visible.description
		if let area = value.area {
			object["area"] = area.rawValue
		}
		if let position = value.position {
			object["position"] = position.description
		}
		switch value.alignment {
			case .leading:
				object["alignment"] = "leading"
			case .trailing:
				object["alignment"] = "trailing"
			case .center:
				object["alignment"] = "center"
			default:
				break
		}
		return object.isEmpty ? nil : object
	}

	public func deserialize(_ object: Serializable?) -> Value? {
		guard let object else { return nil }

		let visible = object["visible"] ?? ""
		let area = object["area"] ?? ""
		let position = object["position"] ?? ""
		let alignment = object["alignment"] ?? ""

		let value = WidgetLayout(
			visible: visible == "true" ? true : false,
			area: area.isEmpty ? nil : BarArea(rawValue: area),
			position: position.isEmpty ? nil : Int(position),
			alignment: {
				switch alignment {
					case "leading":
							.leading
					case "trailing":
							.trailing
					case "center":
							.center
					default:
						nil
				}
			}()
		)
		return value
	}
}
extension WidgetLayout: Defaults.Serializable {
	static let bridge = WidgetLayoutBridge()
}
