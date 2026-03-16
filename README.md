AuroraUI — Modern Roblox UI Framework
Architecture Overview
The framework is organized into logical, modular sections:
Table
Section	Description
Constants	Centralized animation timings, easing styles, sizing, and z-index layers
Theme System	4 built-in presets (Dark, Light, Midnight, Ocean) with runtime switching
Animation System	TweenService wrapper with fade, scale, slide, pulse, and shake effects
Utility Functions	Helper functions for creating instances, applying corners, strokes, shadows, layouts
Event System	Custom Signal class for clean event handling
Base Component	Abstract class with state management, lifecycle hooks, and cleanup
Window System	Draggable, resizable, collapsible windows with title bars
Components	Button, iOS Switch, Slider, TextInput, Dropdown, Label, Section
Tab System	Animated tab containers with sliding indicator
Notification System	Stacking notifications with progress bars and auto-dismiss
Key Features
🎨 Visual Design
Rounded corners (UICorner) on all elements
Subtle shadows for depth
UIStroke borders for visual separation
Consistent spacing with padding system
📱 Cross-Platform Support
Touch input for mobile devices
Minimum 44px touch targets (Apple HIG compliant)
Responsive layouts using UIListLayout, UIPadding, constraints
✨ Smooth Animations
Quint, Quad, and Back easing styles
Professional timing (0.15s fast, 0.25s normal, 0.4s slow)
No harsh transitions — everything feels fluid
🧠 Developer Experience
lua
Copy
-- Load the library
local Aurora = loadstring(game:HttpGet("URL"))()

-- Create a themed window
local Window = Aurora:CreateWindow({
    Title = "My Application",
    Size = UDim2.new(0, 400, 0, 500),
    Theme = Aurora.Theme.Presets.Midnight
})

-- Add components
Window:AddComponent(Aurora:CreateButton({
    Text = "Click Me",
    Style = "Primary",
    Callback = function() print("Clicked!") end
}))

Window:AddComponent(Aurora:CreateSwitch({
    Label = "Enable Feature",
    Callback = function(value) print("Switch:", value) end
}))

-- Show notification
Aurora:Notify({
    Title = "Success!",
    Message = "Operation completed successfully",
    Type = "Success",
    Duration = 3
})
🎭 Theme System
lua
Copy
-- Switch themes at runtime
Aurora:SetTheme("Ocean")

-- Or create custom theme
local customTheme = Aurora.Theme.new("Dark")
customTheme:SetColor("Primary", Color3.fromRGB(255, 0, 128))
🔧 Component API
All components support hover/pressed/disabled states
Callbacks for user interactions
Signal-based events (OnChanged, OnFocus, etc.)
Proper memory cleanup with :Destroy()
Built-in Themes
Table
Theme	Description
Dark	Default modern dark with indigo accents
Light	Clean light theme for bright environments
Midnight	Deep blue-purple aesthetic
Ocean	Cyan-accented aquatic theme
The library returns AuroraUI at the end, making it fully compatible with loadstring execution. All components properly clean up event connections and instances when destroyed to prevent memory leaks.
