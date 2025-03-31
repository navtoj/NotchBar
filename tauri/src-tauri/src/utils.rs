use cocoa::foundation::NSRect;

pub fn print_ns_rect(rect: NSRect, label: &str) {
    let width = rect.size.width;
    let height = rect.size.height;
    let x = rect.origin.x;
    let y = rect.origin.y;
    println!(
        "{}: x = {}, y = {}, width = {}, height = {}",
        if label.is_empty() { "NSRect" } else { label },
        x,
        y,
        width,
        height
    );
}
