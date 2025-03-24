#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![check, svelte])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

#[tauri::command]
fn check(backend: &str) -> bool {
	backend == "active"
}

#[tauri::command]
fn svelte(input: &str) -> usize {
	input.chars().count()
}
