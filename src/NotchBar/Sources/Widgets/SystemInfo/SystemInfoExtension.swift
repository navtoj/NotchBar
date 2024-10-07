import SystemInfoKit

private enum DetailDataUnit : String {
	case percentage = "%"
	case gigabyte = "GB"
}

public struct DetailData: CustomStringConvertible {
	public internal(set) var value: Double
	public internal(set) var unit: String
	public internal(set) var decimalPlaces: Int = 2

	public var description: String {
		return String(format: "%.\(decimalPlaces)f %@", value, unit)
	}
}

private func getNumInfo(details: [String], key: String, unit: String, unitOverride: String = "", decimals: Int = 2) -> DetailData {
	let returnUnit = unitOverride.isEmpty ? unit : unitOverride

	let errorValue = DetailData(value: -1.0, unit: returnUnit, decimalPlaces: decimals)

	guard let detail = details.first(where: { value in
		value.starts(with: key)
	}) else { return errorValue }

	let value = detail
		.replacingOccurrences(of: key, with: "")
		.replacingOccurrences(of: unit, with: "")
		.trimmingCharacters(in: .whitespacesAndNewlines)

	guard let numValue = Double(value) else { return errorValue }

	return DetailData(value: numValue, unit: returnUnit, decimalPlaces: decimals)
}

private func getTextInfo(details: [String], key: String) -> String {
	let errorValue = "nil"

	guard let detail = details.first(where: { value in
		value.starts(with: key)
	}) else { return errorValue }

	let value = detail
		.replacingOccurrences(of: key, with: "")
		.trimmingCharacters(in: .whitespacesAndNewlines)

	return value
}

extension CPUInfo {
	var usage: DetailData {
		getNumInfo(
			details: [summary],
			key: "CPU:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}
	var system: DetailData {
		getNumInfo(
			details: details,
			key: "System:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}
	var user: DetailData {
		getNumInfo(
			details: details,
			key: "User:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}
	var idle: DetailData {
		getNumInfo(
			details: details,
			key: "Idle:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}

}

extension MemoryInfo {
	var usage: DetailData {
		getNumInfo(
			details: [summary],
			key: "Memory:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}
	var pressure: DetailData {
		getNumInfo(
			details: details,
			key: "Pressure:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}
	var appMemory: DetailData {
		getNumInfo(
			details: details,
			key: "App Memory:",
			unit: DetailDataUnit.gigabyte.rawValue
		)
	}
	var wiredMemory: DetailData {
		getNumInfo(
			details: details,
			key: "Wired Memory:",
			unit: DetailDataUnit.gigabyte.rawValue
		)
	}
	var compressed: DetailData {
		getNumInfo(
			details: details,
			key: "Compressed:",
			unit: DetailDataUnit.gigabyte.rawValue
		)
	}
}

extension StorageInfo {
	var usage: DetailData {
		getNumInfo(
			details: [summary],
			key: "Storage:",
			unit: "\(DetailDataUnit.percentage.rawValue) used",
			unitOverride: DetailDataUnit.percentage.rawValue
		)
	}
	var used: DetailData {
		DetailData(value: usedValue.value, unit: usedValue.unit)
	}
	var free: DetailData {
		DetailData(value: availableValue.value, unit: availableValue.unit)
	}
	var total: DetailData {
		DetailData(value: totalValue.value, unit: totalValue.unit)
	}
}
extension BatteryInfo {
	var amount: DetailData {
		getNumInfo(
			details: [summary],
			key: "Battery:",
			unit: DetailDataUnit.percentage.rawValue
		)
	}
	var source: String {
		getTextInfo(details: details, key: "Power Source:")
	}
	var capacity: DetailData {
		getNumInfo(details: details, key: "Max Capacity:", unit: DetailDataUnit.percentage.rawValue)
	}
	var cycles: DetailData {
		getNumInfo(details: details, key: "Cycle Count:", unit: "cycles", decimals: 0)
	}
	var temperature: DetailData {
		getNumInfo(details: details, key: "Temperature:", unit: "℃", unitOverride: "ºC")
	}
}

extension NetworkInfo {
	var name: String {
		nameValue
	}
	var ip: String {
		ipValue
	}
	var upload: DetailData {
		DetailData(value: uploadValue.value, unit: uploadValue.unit)
	}
	var download: DetailData {
		DetailData(value: downloadValue.value, unit: downloadValue.unit)
	}
}
