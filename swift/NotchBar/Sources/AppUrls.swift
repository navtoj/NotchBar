// https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app/
// https://developer.apple.com/documentation/appkit/nsapplicationdelegate/2887193-application
// Info.plist - CFBundleDocumentTypes

import Foundation

enum UrlScheme: String {
	case todo

	var params: [(key: String, action: (String) -> Void)] {
		switch self {
			case .todo: [
				("set", AppState.shared.setTodo(to:)),
				("reset", { _ in
					AppState.shared.setTodo(to: "")
				})
			]
		}
	}
}

func handleScheme(urls: [URL]) {
	let log = Printer()

	// loop through incoming requests

	for url in urls {

		// process url

		guard let scheme = url.scheme,
			  !scheme.isEmpty
		else {
			return log.add("Invalid URL scheme.").print()
		}
		log.add("scheme", scheme) // notchbar

		// validate path

		guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
			  let path = components.path,
			  !path.isEmpty
		else {
			return log.add("Invalid URL path.").print()
		}
		guard let actions = UrlScheme(rawValue: path)?.params else {
			return log.add("Unknown URL Path", "\(path)").print()
		}
		log.add("path", path) // todo

		// validate params

		guard let params = components.queryItems,
			  !params.isEmpty
		else {
			return log.add("Invalid URL params.").print()
		}
		log.add("params", params) // set=a todo item

		// process params individually

		for param in params {

			// validate key & value

			guard let key = param.name as String?,
				  !key.isEmpty,
				  let value = param.value as String?
			else {
				return log.add("Invalid URL Param", "\(param)").print()
			}
			log.add("(key, value)", (key, value)) // ("set", "a todo item")

			// perform action

			guard let action = actions.first(where: { $0.key == key })?.action else {
				return log.add("Unknown URL Param", "\(key)").print()
			}
			action(value)
		}
	}

	// finish logging

	log.print()
}
