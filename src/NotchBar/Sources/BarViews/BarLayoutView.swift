import SwiftUI

enum Side {
	case left
	case right
}

struct BarLayoutView: View {
	let side: Side = .left

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    BarLayoutView()
}
