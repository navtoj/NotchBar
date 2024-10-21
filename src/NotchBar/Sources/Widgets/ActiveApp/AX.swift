// https://developer.apple.com/documentation/applicationservices/carbon_accessibility/attributes
// https://developer.apple.com/documentation/applicationservices/axerror

import AppKit

func get(_ attribute: String, from axElement: AXUIElement, errors: [(error: AXError, message: String)] = []) -> CFTypeRef? {
	var axValue: CFTypeRef?
	let axResult = AXUIElementCopyAttributeValue(axElement, attribute as CFString, &axValue)
	guard let value = axValue else {
#if DEBUG
		let message = "Failed to get attribute: \(attribute)"
		if axResult == .success {
			print(message)
		} else if axResult == .noValue {
			return nil
		} else if let response = errors.first(where: { $0.error == axResult })?.message {
			print(response)
		} else {
			print (message + " with error: \(axResult)")
		}
#endif
		return nil
	}
	return value
}

func attributes(of axElement: AXUIElement) -> [String]? {
	var axValue: CFArray?
	let axResult = AXUIElementCopyAttributeNames(axElement, &axValue)
	guard let value = axValue as NSArray? else {
#if DEBUG
		let message = "Failed to get attributes."
		if axResult == .success {
			print(message)
		} else {
			print(message + " with error: \(axResult)")
		}
#endif
		return nil
	}
	return value.compactMap { attribute in
		guard let key = attribute as? String else {
#if DEBUG
			print("Failed to cast attribute to String.", attribute)
#endif
			return nil
		}
		return key
	}
}

func list(of attributes: [String], from axElement: AXUIElement, errors: [(error: AXError, message: String)] = []) -> [(attribute: String, value: CFTypeRef)] {
	attributes.compactMap { attribute in
		guard let value = get(attribute, from: axElement) else { return nil }
		return (attribute, value)
	}
}
