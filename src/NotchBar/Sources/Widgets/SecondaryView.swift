//
//  SecondaryView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-30.
//

import SwiftUI

struct SecondaryView: View {
	@Binding var expand: Bool

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
			expand = false
		}
	}
}

#Preview {
	@Previewable @State var expand = true
	SecondaryView(expand: $expand)
}
