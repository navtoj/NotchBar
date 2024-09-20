<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/1339ac43-8374-4951-95e9-9ea9d00aa631">
<!--     <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/ed2e2920-a09c-4b0a-b671-9642ff11f2cb"> -->
    <img alt="The NotchBar app icon." src="NotchBar/Assets.xcassets/AppIcon.appiconset/256.png" width=256 height=256>
  </picture>
  <h1>NotchBar</h1>
</div>

NotchBar is a macOS app designed to utilize the empty space around the notch when connected to external displays.

### Before
![macOS Notch](https://github.com/user-attachments/assets/380fba56-057a-46ed-a4b3-6155e3c7c379)
### After
![NotchBar App](https://github.com/user-attachments/assets/08521f3e-3841-4dfc-9949-0e5a2cadd35e)

## Usage

After launching NotchBar, it will automatically cover the notch area of your MacBook.

A _sparkle_ icon will also be shown in the menu bar for important actions.

![Menu Bar Icon](https://github.com/user-attachments/assets/44012caa-dd0c-47f2-b17f-25e1c622c302)

<!-- (![Sparkle Icon](https://github.com/user-attachments/assets/63dc54dd-3738-40ac-9f6f-4e41bd7a60d4)) -->
<!-- ![Menu Bar Drop-down](https://github.com/user-attachments/assets/19a55bef-c666-4413-92fa-c07869690124) -->

## Installation

> Requirements: macOS 14.5 or later

1. Download the [latest release](https://github.com/navtoj/NotchBar/releases/latest/download/NotchBar.dmg) from the [Releases](https://github.com/navtoj/NotchBar/releases) page.
2. Drag the NotchBar app to your Applications folder.
3. Launch NotchBar from your Applications folder or Spotlight.

![Install.dmg](https://github.com/user-attachments/assets/2c6b0a92-907b-45d4-9023-6eef56f78e11)

## Widgets

<table>
  <tr></tr>
  <tr><th colspan="5" align="left">📊 System Monitor</th></tr>
  <tr><td colspan="5"><img src="https://github.com/user-attachments/assets/86525f16-480b-4373-bf72-afd7624bc845" /></td></tr>
  <tr>
    <td>CPU</td>
    <td>Memory</td>
    <td>Storage</td>
    <td>Battery</td>
    <td>Network</td>
  </tr>
</table>
<table>
  <tr></tr>
  <tr><th colspan="3" align="left">🎵 Media Playback</th></tr>
  <tr><td colspan="3"><img src="https://github.com/user-attachments/assets/91bc4a8c-555d-477b-bd45-663ed52bf27e" /></td></tr>
  <tr>
    <td>Artwork</td>
    <td>Artist</td>
    <td>Track</td>
  </tr>
</table>
<table>
  <tr></tr>
  <tr><th colspan="2" align="left">📱 Active App</th></tr>
  <tr><td colspan="2"><img src="https://github.com/user-attachments/assets/9f6abb92-6f3f-4f6f-9dd6-19f1636bbfbf" /></td></tr>
  <tr>
    <td>Name</td>
    <td>Icon</td>
  </tr>
</table>

|✨|more coming soon...|
|-|:-|
<!-- |![NotchBar](https://github.com/user-attachments/assets/5f573d80-4b03-40db-b7e9-f05b174d3726)| -->

## Contributing

Contributions to NotchBar are most welcome! Please feel free to submit a Pull Request.

## Building from Source

To build NotchBar from source:

1. Clone the repository: git clone https://github.com/navtoj/NotchBar.git
2. Open `NotchBar.xcodeproj` in Xcode.
3. Build and run the project.

## License

This project is licensed under the [AGPLv3 License](LICENSE).

## Acknowledgments

- [SystemInfoKit](https://github.com/Kyome22/SystemInfoKit) for live system information.
- [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols) for safe usage of SF Symbols.
- [LaunchAtLogin-Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern) for launch at login functionality.
- [Pow](https://github.com/EmergeTools/Pow) for SwiftUI effects.