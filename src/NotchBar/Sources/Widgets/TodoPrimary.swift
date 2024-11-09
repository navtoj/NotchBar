import SwiftUI
import Defaults

struct TodoPrimary: PrimaryViewType {
	static let id = "TodoPrimary"

	init(expand: Binding<Bool>) {}

	@Default(.todoWidget) var todo

    var body: some View {
		if !todo.isEmpty {
			Text(todo)
				.lineLimit(1)
		}
    }
}

#Preview {
	@Previewable @State var expand = true
	TodoPrimary(expand: $expand)
}
