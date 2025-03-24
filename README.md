<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="_assets/icon/dark.png" />
    <source media="(prefers-color-scheme: light)" srcset="_assets/icon/light.png" />
    <img alt="The NotchBar app icon." src="_assets/icon/light.png" height=256 />
  </picture>
  <h1>NotchBar</h1>
</div>

NotchBar is a macOS app designed for the empty space around your notch.

### Before
<img src="_assets/intro/before.png" />

### After
<img src="_assets/intro/after.png" />

## Installation

> Requirements: macOS 14.5 or later

1. Download the [`NotchBar.zip`](https://github.com/navtoj/NotchBar/releases/download/0.0.3.2/NotchBar.zip) from the [Releases](https://github.com/navtoj/NotchBar/releases/latest) page.
2. Unzip and drag the `NotchBar.app` to your **Applications** folder.
3. Launch **NotchBar** from your Applications folder or Spotlight.

> [!TIP]
> ### Can't open `NotchBar.app`?
<details>
<summary>Use this quick workaround.</summary><br>

> |Step 1|Step 2|Step 3|
> |:-|:-|:-|
> |Click `Show in Finder`|_Right_ Click `NotchBar.app` → Click `Open`|Again, Click `Open`|
> |<img width="260" src="_assets/install/solution.1.0.png" alt="Solution 1.0">[^1]|<img width="440" src="_assets/install/solution.1.1.png" alt="Solution 1.1">|<img width="205" src="_assets/install/solution.1.2.png" alt="Solution 1.2">|
> #### If the `Show in Finder` button is not visible...
> <img src="_assets/install/solution.2.0.png" alt="Solution 2.0">[^2]
>
> |Step 0|
> |:-|
> |Open `Terminal` → Run `chmod +x /Applications/NotchBar.app/Contents/MacOS/NotchBar`|
> |<img width="2091.737704918" src="_assets/install/solution.2.1.png" alt="Solution 2.1">|

[^1]: This popup appears because Apple requires a **CAD $119** yearly subscription to remove it.
[^2]: This popup appears because the macOS `Archive Utility` breaks file permissions for the executable within the `.app` bundle.
</details>

## Usage

After launching NotchBar, it will automatically cover the notch area of your MacBook.

A _sparkle_ icon will also be shown in the menu bar for important actions.

<img src="_assets/usage/menuBarItem.png" />

> [!TIP]
> ### Can't see the `NotchBar`?
<details>
<summary>It might be covered by the macOS menu bar.</summary><br>

> **Option 1 —** Set **`Automatically hide and show the menu bar`** option to **`Always`**
> <img alt="Menu Bar Setting" src="_assets/usage/settingsMenuBar.png">
> <br>**Option 2 —** Set **`Displays have separate Spaces`** option to **`Off`**
> <img alt="Spaces Setting" src="_assets/usage/settingsSpaces.png">
</details>

## Repo Stats

[![Repobeats Analytics Image](https://repobeats.axiom.co/api/embed/1347103aebc5b2acfeec016a3534b3dc061e423d.svg)](https://github.com/navtoj/NotchBar/graphs/contributors)

<a href="https://star-history.com/#navtoj/notchbar&Timeline">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=navtoj/notchbar&type=Timeline&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=navtoj/notchbar&type=Timeline" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=navtoj/notchbar&type=Timeline" />
 </picture>
</a>
