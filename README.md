# 🐱 CAT HUB Library

A reusable Roblox Lua GUI library created by **CATJack.gg** for building interfaces in your own Roblox experiences.

## ✨ Features

- Customizable themes
- Draggable window with close button
- Tabs and sections
- Buttons and toggles
- Numeric sliders
- Dropdown menus
- Text input boxes
- Keyboard keybinds
- Preset color picker
- Toast notifications
- JSON settings encode/decode helpers


- **Raw source:** ```lua https://raw.githubusercontent.com/CatJackop/CATHUBGUI-/refs/heads/main/CAT_HUB_Library.lua```


## 🚀 Quick Start

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CAT = require(ReplicatedStorage:WaitForChild("CAT_HUB_Library"))

local Window = CAT:CreateWindow({
    Title = "CAT HUB Library",
    Width = 620,
    Height = 430,
})

Window:Notify({
    Title = "Welcome",
    Content = "CAT HUB Library loaded!",
    Duration = 3,
})

local Main = Window:CreateTab({Name = "Main"})
local Section = Main:AddSection("General")

Section:AddButton({
    Name = "Test Button",
    Callback = function()
        Window:Notify({
            Title = "CAT HUB",
            Content = "Button clicked!",
            Duration = 3,
        })
    end,
})

Section:AddToggle({
    Name = "Example Toggle",
    Default = false,
    Callback = function(enabled)
        print("Toggle state:", enabled)
    end,
})

Section:AddSlider({
    Name = "Example Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end,
})
```

## 🧩 Available Controls

- `AddButton()` — run an action when clicked.
- `AddToggle()` — switch a value on or off.
- `AddSlider()` — choose a numeric value within a range.
- `AddDropdown()` — cycle through a list of options.
- `AddTextBox()` — accept text input.
- `AddKeybind()` — set and listen for a keyboard shortcut.
- `AddColorPicker()` — cycle through preset colors.
- `AddSection()` — group related controls inside a tab.

## 🔔 Notifications

```lua
Window:Notify({
    Title = "Notice",
    Content = "Your action completed.",
    Duration = 3,
})
```

## 🎨 Custom Theme

Set a theme before creating the window:

```lua
CAT:SetTheme({
    Background = Color3.fromRGB(16, 17, 21),
    Panel = Color3.fromRGB(27, 29, 35),
    PanelHover = Color3.fromRGB(42, 44, 51),
    Accent = Color3.fromRGB(255, 190, 55),
    Text = Color3.fromRGB(245, 245, 245),
    Muted = Color3.fromRGB(165, 165, 170),
    Stroke = Color3.fromRGB(65, 67, 75),
})
```

## 💾 Settings Helpers

```lua
local settings = {
    Enabled = true,
    Volume = 75,
}

local json = CAT:EncodeSettings(settings)
local decoded = CAT:DecodeSettings(json)

print(decoded.Volume)
```

**Note:** These helpers encode and decode JSON only. They do not save settings across sessions. Persistent saving requires a server-side DataStore implementation in your own experience.

## ⚠️ Notes

- Use this library in your own Roblox experiences and test it in Roblox Studio.
- The library returns a table; load it as a `ModuleScript` with `require()`.
- The dropdown currently advances through options when clicked.
- The color picker cycles through preset colors; it is not a free-form RGB picker.
- Test keyboard and touch behavior before publishing.

## 👤 Credits

**Library:** CAT HUB Library  
**Creator:** CATJack.gg  
**Platform:** Roblox

---

Made with care by **CATJack.gg**.
