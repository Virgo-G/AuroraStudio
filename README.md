# AuroraUI --- Modern Roblox UI Framework

AuroraUI is a **modern, modular UI framework for Roblox** designed to
help developers quickly build polished interfaces with smooth
animations, responsive layouts, and a clean component architecture.

The library focuses on **developer experience, performance, and visual
consistency**, making it suitable for games, developer tools, and
scripting frameworks.

------------------------------------------------------------------------

# ✨ Features

## 🎨 Modern Visual Design

-   Rounded corners using `UICorner`
-   Subtle shadows for depth
-   `UIStroke` borders for separation
-   Consistent spacing with a padding system
-   Clean, modern layout structure

## 📱 Cross-Platform Support

-   Full **touch support** for mobile devices\
-   **Minimum 44px touch targets** (Apple HIG compliant)\
-   Responsive layouts using:
    -   `UIListLayout`
    -   `UIPadding`
    -   Layout constraints

## ✨ Smooth Animations

-   Professional animation system built on `TweenService`
-   Easing styles:
    -   Quint
    -   Quad
    -   Back
-   Balanced timing presets:
    -   **0.15s** --- Fast
    -   **0.25s** --- Normal
    -   **0.40s** --- Slow

All transitions are designed to feel **fluid and natural**.

## 🧠 Developer Experience

-   Clean API
-   Modular architecture
-   Signal-based event system
-   Automatic cleanup to prevent memory leaks

------------------------------------------------------------------------

# 🏗 Architecture Overview

AuroraUI is organized into modular systems.

  -----------------------------------------------------------------------
  Section                             Description
  ----------------------------------- -----------------------------------
  **Constants**                       Centralized animation timings,
                                      easing styles, sizing, and z-index
                                      layers

  **Theme System**                    4 built-in themes with runtime
                                      switching

  **Animation System**                TweenService wrapper with fade,
                                      scale, slide, pulse, and shake

  **Utility Functions**               Instance creation helpers, corners,
                                      strokes, shadows, layouts

  **Event System**                    Custom `Signal` class for event
                                      handling

  **Base Component**                  Abstract class with lifecycle hooks
                                      and state management

  **Window System**                   Draggable, resizable, collapsible
                                      windows

  **Components**                      Button, Switch, Slider, TextInput,
                                      Dropdown, Label, Section

  **Tab System**                      Animated tab containers with
                                      sliding indicator

  **Notification System**             Stacking notifications with
                                      progress bars
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 🚀 Quick Start

``` lua
-- Load the library
local Aurora = loadstring(game:HttpGet("https://raw.githubusercontent.com/Virgo-G/AuroraStudio/refs/heads/main/AuroraUI.lua"))()

-- Create a window
local Window = Aurora:CreateWindow({
    Title = "My Application",
    Size = UDim2.new(0, 400, 0, 500),
    Theme = Aurora.Theme.Presets.Midnight
})

-- Add a button
Window:AddComponent(Aurora:CreateButton({
    Text = "Click Me",
    Style = "Primary",
    Callback = function()
        print("Clicked!")
    end
}))

-- Add a switch
Window:AddComponent(Aurora:CreateSwitch({
    Label = "Enable Feature",
    Callback = function(value)
        print("Switch:", value)
    end
}))

-- Show a notification
Aurora:Notify({
    Title = "Success!",
    Message = "Operation completed successfully",
    Type = "Success",
    Duration = 3
})
```

------------------------------------------------------------------------

# 🎭 Theme System

AuroraUI includes built-in themes and runtime switching.

``` lua
Aurora:SetTheme("Ocean")
```

## Creating a Custom Theme

``` lua
local customTheme = Aurora.Theme.new("Dark")

customTheme:SetColor(
    "Primary",
    Color3.fromRGB(255, 0, 128)
)
```

------------------------------------------------------------------------

# 🧩 Component API

All components support:

-   Hover / Pressed / Disabled states
-   Callback functions
-   Signal-based events (`OnChanged`, `OnFocus`, etc.)
-   Automatic cleanup using `:Destroy()`

------------------------------------------------------------------------

# 🎨 Built-in Themes

  Theme          Description
  -------------- -------------------------------------------
  **Dark**       Default modern dark with indigo accents
  **Light**      Clean light theme for bright environments
  **Midnight**   Deep blue-purple aesthetic
  **Ocean**      Cyan-accented aquatic theme

------------------------------------------------------------------------

# 🧹 Memory Safety

AuroraUI is designed with **proper lifecycle management**.

-   All components clean up event connections
-   Instances are destroyed correctly
-   Prevents memory leaks in long-running experiences

------------------------------------------------------------------------

# 📦 Compatibility

AuroraUI returns the framework table at the end of the script, allowing
it to be used with:

``` lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Virgo-G/AuroraStudio/refs/heads/main/AuroraUI.lua"))()
```

This makes the framework compatible with **Roblox scripting environments
and developer tools**.
