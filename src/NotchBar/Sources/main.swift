import AppKit

// initialize application

let app = NSApplication.shared

// initialize delegate

let appDelegate = AppDelegate.shared

// assign delegate

app.delegate = appDelegate

// start app

app.run()
