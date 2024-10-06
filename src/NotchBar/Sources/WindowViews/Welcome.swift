import SwiftUI

struct Welcome: View {
	let size: CGFloat = 200

	var body: some View {
		Rectangle()
			.fill(.foreground)
			.frame(width: size, height: size)
			.clipShape(RoundCornersInvertedTop(radius: size / 2))
			.border(.green)
			.overlay {
				ZStack {
					Rectangle()
						.fill(.red)
						.frame(width: size * 1.5, height: 1)
					Rectangle()
						.fill(.red)
						.frame(width: 1, height: size * 1.5)
				}
				.border(.blue)
			}
			.padding(size)
			.background(.background)
			.roundedCorners()
	}
}

#Preview {
	Welcome()
}
