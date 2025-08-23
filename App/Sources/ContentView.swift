import LaunchAtLogin
import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			LaunchAtLogin.Toggle("Open at Login")
		}
		.padding()
	}
}

#Preview {
	ContentView()
}
