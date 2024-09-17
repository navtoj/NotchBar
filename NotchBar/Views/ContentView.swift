//
//  ContentView.swift
//  NotchBar
//
//  Created by Navtoj Chahal on 2024-09-04.
//

import SwiftUI
import SFSafeSymbols
import Pow

struct ContentView: View {
	@Environment(\.colorScheme) var theme
	
	var body: some View {
		VStack {
			NotchBar()
				.invertedBottomCorners(background: theme == .dark ? .black : Color(.textBackgroundColor), radius: 10)
#if DEBUG
//				.preferredColorScheme(.light)
#else
				.preferredColorScheme(.dark)
#endif
		}
		.frame(maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	ContentView()
		.frame(minWidth: NSScreen.builtIn?.frame.width)
}
