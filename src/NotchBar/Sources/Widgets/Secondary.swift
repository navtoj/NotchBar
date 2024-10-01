//
//  Secondary.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-30.
//

import SwiftUI

struct Secondary: View {
	@Binding var show: Bool

	var body: some View {
		HStack {
			Text("Secondary View")
			Text("Secondary View")
			Text("Secondary View")
		}
		.fixedSize()
		.padding(5)
		.background(.background)
		.onTapGesture {
			print("Tap Secondary")
			AppState.shared.toggleSettings()
			show = false
		}
	}
}

#Preview {
	@Previewable @State var show = true
	Secondary(show: $show)
}
