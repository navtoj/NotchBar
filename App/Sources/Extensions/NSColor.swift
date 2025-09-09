import AppKit

public extension NSColor {
	convenience init?(hex: String) {
		var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		hexString = hexString.replacingOccurrences(of: "#", with: "")

		var rgbValue: UInt64 = 0
		guard Scanner(string: hexString).scanHexInt64(&rgbValue) else {
			return nil
		}

		switch hexString.count {
			case 3:
				// RGB (12-bit)
				let red = CGFloat((rgbValue & 0xF00) >> 8) / 15.0
				let green = CGFloat((rgbValue & 0x0F0) >> 4) / 15.0
				let blue = CGFloat(rgbValue & 0x00F) / 15.0
				self.init(red: red, green: green, blue: blue, alpha: 1.0)

			case 6:
				// RRGGBB (24-bit)
				let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
				let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
				let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
				self.init(red: red, green: green, blue: blue, alpha: 1.0)

			case 8:
				// RRGGBBAA (32-bit)
				let red = CGFloat((rgbValue & 0xFF00_0000) >> 24) / 255.0
				let green = CGFloat((rgbValue & 0x00FF_0000) >> 16) / 255.0
				let blue = CGFloat((rgbValue & 0x0000_FF00) >> 8) / 255.0
				let alpha = CGFloat(rgbValue & 0x0000_00FF) / 255.0
				self.init(red: red, green: green, blue: blue, alpha: alpha)

			default:
				return nil
		}
	}
}
