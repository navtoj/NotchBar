import SwiftUICore
import AppKit

extension NSColor {
	
	/// Returns the lightness of the color.
	var luminance: Double {
		// get rgb values
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		self.getRed(&red, green: &green, blue: &blue, alpha: nil)

		// compute luminance
		return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
	}
}
