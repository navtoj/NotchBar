import AppKit

// MARK: Instances

let app = NSApplication.shared
let delegate = AppDelegate.shared

// MARK: Linking

app.delegate = delegate

// MARK: Run Loop

app.run()
