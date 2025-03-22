import AppKit

extension NSImage {

	/// Returns the average color of the image.
	var averageColor: NSColor? {
		// https://gist.github.com/bbaars/0851c25df14941becc7a0307e41cf716
		
		// get image data
		guard let imageData = self.tiffRepresentation else { return nil }

		// create core image
		guard let inputImage = CIImage(data: imageData) else { return nil }

		// create an extent vector
		let extentVector = CIVector(
			x: inputImage.extent.origin.x,
			y: inputImage.extent.origin.y,
			z: inputImage.extent.size.width,
			w: inputImage.extent.size.height
		)

		// create CIAreaAverage filter
		guard let filter = CIFilter(
			name: "CIAreaAverage",
			parameters: [
				kCIInputImageKey: inputImage,
				kCIInputExtentKey: extentVector
			]
		) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }

		// create bitmap for (r, g, b, a) value
		var bitmap = [UInt8](repeating: 0, count: 4)
		guard let kCFNull = kCFNull else { return nil }
		let context = CIContext(options: [.workingColorSpace: kCFNull])

		// render output image
		context.render(
			outputImage,
			toBitmap: &bitmap,
			rowBytes: 4,
			bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
			format: .RGBA8,
			colorSpace: nil
		)

		// create ns color
		return NSColor(
			red: CGFloat(bitmap[0]) / 255,
			green: CGFloat(bitmap[1]) / 255,
			blue: CGFloat(bitmap[2]) / 255,
			alpha: CGFloat(bitmap[3]) / 255
		)
	}
}
