mod ns_screen;
mod utils;

use cocoa::{
    appkit::{NSScreen, NSWindow, NSWindowCollectionBehavior},
    base::id,
};
use ns_screen::get_internal_screen;
use tauri::{WebviewUrl, WebviewWindowBuilder, is_dev};
use utils::print_ns_rect;

pub fn run() {
    tauri::Builder::default()
        .setup(|app| {
            let webview_window = WebviewWindowBuilder::new(app, "main", WebviewUrl::default())
                .inner_size(600.0, 400.0)
                .decorations(false)
                .shadow(false)
                .transparent(true)
                .center()
                // .position(100.0, 100.0)
                .build()
                .unwrap();

            // show devtools on launch
            #[cfg(debug_assertions)]
            // webview_window.open_devtools();

            // configure window
            let ns_window = webview_window.ns_window().unwrap() as id;
            unsafe {
                ns_window.setLevel_(1);
                ns_window.setCollectionBehavior_(
                    NSWindowCollectionBehavior::NSWindowCollectionBehaviorCanJoinAllSpaces
                        | NSWindowCollectionBehavior::NSWindowCollectionBehaviorStationary
                        | NSWindowCollectionBehavior::from_bits_truncate(1 << 9)
                        | NSWindowCollectionBehavior::NSWindowCollectionBehaviorIgnoresCycle,
                );
                // ns_window.setMovableByWindowBackground_(true);
                ns_window.setMovable_(false);
                // TODO: change based on cursor position?
                ns_window.setIgnoresMouseEvents_(true);
            }
            reset_window_frame(ns_window);

            Ok(())
        })
        .on_window_event(|window, event| match event {
            tauri::WindowEvent::Resized(_) | tauri::WindowEvent::Moved(_) => {
                let ns_window = window.ns_window().unwrap() as id;
                reset_window_frame(ns_window);
            }
            _ => {}
        })
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![check])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");

    fn reset_window_frame(ns_window: id) {
        unsafe {
            if let Some(internal) = get_internal_screen() {
                let frame = NSScreen::frame(internal);
                NSWindow::setContentSize_(ns_window, frame.size);
                NSWindow::setFrameOrigin_(ns_window, frame.origin);
                if is_dev() {
                    print_ns_rect(NSWindow::frame(ns_window), "Window frame")
                }
            } else {
                panic!("No internal screen found.");
            }
        }
    }
}

#[tauri::command]
fn check(backend: &str) -> bool {
    backend == "active"
}
