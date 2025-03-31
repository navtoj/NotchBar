use cocoa::{
    appkit::NSScreen,
    base::{id, nil},
    foundation::{NSArray, NSDictionary, NSString},
};
use core_graphics::display::CGDisplayIsBuiltin;
use objc2_foundation::NSNumber;
use tauri::is_dev;

use crate::utils::print_ns_rect;

pub fn get_internal_screen() -> Option<id> {
    unsafe {
        let screens = NSScreen::screens(nil);
        let screen_count = NSArray::count(screens);
        for i in 0..screen_count {
            let screen = screens.objectAtIndex(i);
            let device_description = screen.deviceDescription();
            let screen_number_key = NSString::alloc(nil).init_str("NSScreenNumber");

            let screen_number: id = device_description.valueForKey_(screen_number_key);
            let display_id: *const NSNumber = screen_number.cast();
            let display_id = { &*display_id };
            let display_id = display_id.as_u32();
            // let screen_number = device_description.objectForKey_(screen_number_key);
            // let display_id = msg_send![screen_number, unsignedIntegerValue];

            if is_dev() {
                print_ns_rect(screen.frame(), "Screen frame")
            }

            if CGDisplayIsBuiltin(display_id) == 1 {
                return Some(screen);
            }
        }
    }
    None
}
