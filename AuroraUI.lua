--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                           A U R O R A   U I                               ║
    ║                    Modern Roblox UI Framework v1.0                        ║
    ║                                                                           ║
    ║  A production-ready, professional UI library for Roblox experiences.    ║
    ║  Designed with performance, scalability, and developer experience in mind.║
    ║                                                                           ║
    ║  Features:                                                                ║
    ║  • Modern, polished visual design with rounded corners and depth          ║
    ║  • Comprehensive theme system with runtime customization                  ║
    ║  • Smooth animations using TweenService with professional easing          ║
    ║  • Responsive layouts that adapt to PC, Mobile, and Tablet                ║
    ║  • Draggable windows with intelligent positioning                         ║
    ║  • Rich component library (Buttons, Switches, Sliders, Inputs, etc.)      ║
    ║  • Tab system with smooth transitions                                     ║
    ║  • Notification system with intelligent stacking                          ║
    ║  • Full touch input support for mobile devices                            ║
    ║  • Memory-safe architecture with proper cleanup                           ║
    ║                                                                           ║
    ║  Usage:                                                                   ║
    ║      local Aurora = loadstring(game:HttpGet("URL"))()                     ║
    ║      local Window = Aurora:CreateWindow({ title = "My App" })             ║
    ║                                                                           ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
--]]

local AuroraUI = {}
AuroraUI.__index = AuroraUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Constants & Configuration
-- ═══════════════════════════════════════════════════════════════════════════════

local CONSTANTS = {
    -- Animation timings
    ANIMATION_FAST = 0.15,
    ANIMATION_NORMAL = 0.25,
    ANIMATION_SLOW = 0.4,
    
    -- Easing styles
    EASE_OUT_QUINT = Enum.EasingStyle.Quint,
    EASE_OUT_QUAD = Enum.EasingStyle.Quad,
    EASE_OUT_BACK = Enum.EasingStyle.Back,
    EASE_IN_OUT_QUAD = Enum.EasingStyle.Quad,
    
    -- Default sizes
    WINDOW_MIN_WIDTH = 300,
    WINDOW_MIN_HEIGHT = 200,
    TITLE_BAR_HEIGHT = 36,
    COMPONENT_HEIGHT = 32,
    TOUCH_MIN_SIZE = 44, -- Apple's recommended minimum touch target
    
    -- Spacing
    PADDING_SMALL = 4,
    PADDING_MEDIUM = 8,
    PADDING_LARGE = 12,
    PADDING_XLARGE = 16,
    
    -- Corner radius
    CORNER_SMALL = 4,
    CORNER_MEDIUM = 6,
    CORNER_LARGE = 8,
    CORNER_XLARGE = 12,
    
    -- Z-index layers
    LAYER_WINDOW = 100,
    LAYER_MODAL = 200,
    LAYER_NOTIFICATION = 300,
    LAYER_TOOLTIP = 400,
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Theme System
-- ═══════════════════════════════════════════════════════════════════════════════

local Theme = {}
Theme.__index = Theme

Theme.Presets = {
    Dark = {
        -- Background colors
        Background = Color3.fromRGB(25, 25, 30),
        BackgroundSecondary = Color3.fromRGB(35, 35, 42),
        BackgroundTertiary = Color3.fromRGB(45, 45, 54),
        
        -- Surface colors
        Surface = Color3.fromRGB(55, 55, 66),
        SurfaceHover = Color3.fromRGB(65, 65, 78),
        SurfacePressed = Color3.fromRGB(75, 75, 90),
        
        -- Accent colors
        Primary = Color3.fromRGB(99, 102, 241), -- Indigo
        PrimaryHover = Color3.fromRGB(129, 140, 248),
        PrimaryPressed = Color3.fromRGB(79, 70, 229),
        
        -- Semantic colors
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246),
        
        -- Text colors
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(156, 163, 175),
        TextTertiary = Color3.fromRGB(107, 114, 128),
        TextDisabled = Color3.fromRGB(75, 85, 99),
        
        -- Border colors
        Border = Color3.fromRGB(75, 85, 99),
        BorderActive = Color3.fromRGB(99, 102, 241),
        
        -- Special
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
    },
    
    Light = {
        Background = Color3.fromRGB(255, 255, 255),
        BackgroundSecondary = Color3.fromRGB(249, 250, 251),
        BackgroundTertiary = Color3.fromRGB(243, 244, 246),
        
        Surface = Color3.fromRGB(229, 231, 235),
        SurfaceHover = Color3.fromRGB(209, 213, 219),
        SurfacePressed = Color3.fromRGB(156, 163, 175),
        
        Primary = Color3.fromRGB(79, 70, 229),
        PrimaryHover = Color3.fromRGB(99, 102, 241),
        PrimaryPressed = Color3.fromRGB(67, 56, 202),
        
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246),
        
        TextPrimary = Color3.fromRGB(17, 24, 39),
        TextSecondary = Color3.fromRGB(75, 85, 99),
        TextTertiary = Color3.fromRGB(107, 114, 128),
        TextDisabled = Color3.fromRGB(156, 163, 175),
        
        Border = Color3.fromRGB(209, 213, 219),
        BorderActive = Color3.fromRGB(99, 102, 241),
        
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
    },
    
    Midnight = {
        Background = Color3.fromRGB(15, 23, 42),
        BackgroundSecondary = Color3.fromRGB(30, 41, 59),
        BackgroundTertiary = Color3.fromRGB(51, 65, 85),
        
        Surface = Color3.fromRGB(71, 85, 105),
        SurfaceHover = Color3.fromRGB(100, 116, 139),
        SurfacePressed = Color3.fromRGB(148, 163, 184),
        
        Primary = Color3.fromRGB(139, 92, 246), -- Violet
        PrimaryHover = Color3.fromRGB(167, 139, 250),
        PrimaryPressed = Color3.fromRGB(124, 58, 237),
        
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(248, 113, 113),
        Info = Color3.fromRGB(96, 165, 250),
        
        TextPrimary = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(203, 213, 225),
        TextTertiary = Color3.fromRGB(148, 163, 184),
        TextDisabled = Color3.fromRGB(100, 116, 139),
        
        Border = Color3.fromRGB(71, 85, 105),
        BorderActive = Color3.fromRGB(139, 92, 246),
        
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
    },
    
    Ocean = {
        Background = Color3.fromRGB(12, 20, 30),
        BackgroundSecondary = Color3.fromRGB(20, 35, 50),
        BackgroundTertiary = Color3.fromRGB(30, 50, 70),
        
        Surface = Color3.fromRGB(40, 65, 90),
        SurfaceHover = Color3.fromRGB(50, 80, 110),
        SurfacePressed = Color3.fromRGB(60, 95, 130),
        
        Primary = Color3.fromRGB(6, 182, 212), -- Cyan
        PrimaryHover = Color3.fromRGB(34, 211, 238),
        PrimaryPressed = Color3.fromRGB(8, 145, 178),
        
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(248, 113, 113),
        Info = Color3.fromRGB(56, 189, 248),
        
        TextPrimary = Color3.fromRGB(236, 254, 255),
        TextSecondary = Color3.fromRGB(165, 243, 252),
        TextTertiary = Color3.fromRGB(103, 232, 249),
        TextDisabled = Color3.fromRGB(72, 85, 99),
        
        Border = Color3.fromRGB(40, 65, 90),
        BorderActive = Color3.fromRGB(6, 182, 212),
        
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
    }
}

function Theme.new(presetName)
    local self = setmetatable({}, Theme)
    self.colors = table.clone(Theme.Presets[presetName or "Dark"])
    self.listeners = {}
    return self
end

function Theme:GetColor(key)
    return self.colors[key] or self.colors.TextPrimary
end

function Theme:SetColor(key, color)
    self.colors[key] = color
    self:NotifyChange(key, color)
end

function Theme:Apply(presetName)
    if Theme.Presets[presetName] then
        self.colors = table.clone(Theme.Presets[presetName])
        self:NotifyChange("*", self.colors)
    end
end

function Theme:OnChange(callback)
    table.insert(self.listeners, callback)
    return function()
        for i, listener in ipairs(self.listeners) do
            if listener == callback then
                table.remove(self.listeners, i)
                break
            end
        end
    end
end

function Theme:NotifyChange(key, value)
    for _, listener in ipairs(self.listeners) do
        task.spawn(listener, key, value)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Animation System
-- ═══════════════════════════════════════════════════════════════════════════════

local Animation = {}
Animation.__index = Animation

Animation.ActiveTweens = {}

function Animation.Tween(object, properties, duration, easingStyle, easingDirection, callback)
    if not object or not object.Parent then return nil end
    
    duration = duration or CONSTANTS.ANIMATION_NORMAL
    easingStyle = easingStyle or CONSTANTS.EASE_OUT_QUINT
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    -- Cancel existing tween for this object
    if Animation.ActiveTweens[object] then
        Animation.ActiveTweens[object]:Cancel()
    end
    
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle,
        easingDirection
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    Animation.ActiveTweens[object] = tween
    
    tween.Completed:Connect(function()
        Animation.ActiveTweens[object] = nil
        if callback then
            callback()
        end
    end)
    
    tween:Play()
    return tween
end

function Animation.FadeIn(object, duration, callback)
    object.BackgroundTransparency = 1
    return Animation.Tween(object, {BackgroundTransparency = 0}, duration, nil, nil, callback)
end

function Animation.FadeOut(object, duration, callback)
    return Animation.Tween(object, {BackgroundTransparency = 1}, duration, nil, nil, callback)
end

function Animation.ScaleIn(object, duration, callback)
    object.Size = UDim2.new(0, 0, 0, 0)
    return Animation.Tween(object, {Size = UDim2.new(1, 0, 1, 0)}, duration, CONSTANTS.EASE_OUT_BACK, nil, callback)
end

function Animation.SlideIn(object, direction, distance, duration, callback)
    local originalPosition = object.Position
    local offset = {
        Left = UDim2.new(0, -distance, 0, 0),
        Right = UDim2.new(0, distance, 0, 0),
        Up = UDim2.new(0, 0, 0, -distance),
        Down = UDim2.new(0, 0, 0, distance)
    }
    
    object.Position = originalPosition + (offset[direction] or offset.Right)
    return Animation.Tween(object, {Position = originalPosition}, duration, CONSTANTS.EASE_OUT_QUINT, nil, callback)
end

function Animation.Pulse(object, scale, duration)
    scale = scale or 1.05
    duration = duration or 0.3
    
    local originalSize = object.Size
    local expandedSize = UDim2.new(
        originalSize.X.Scale * scale,
        originalSize.X.Offset * scale,
        originalSize.Y.Scale * scale,
        originalSize.Y.Offset * scale
    )
    
    Animation.Tween(object, {Size = expandedSize}, duration / 2, CONSTANTS.EASE_OUT_QUAD, nil, function()
        Animation.Tween(object, {Size = originalSize}, duration / 2, CONSTANTS.EASE_OUT_QUAD)
    end)
end

function Animation.Shake(object, intensity, duration)
    intensity = intensity or 10
    duration = duration or 0.5
    
    local originalPosition = object.Position
    local startTime = tick()
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            object.Position = originalPosition
            connection:Disconnect()
            return
        end
        
        local decay = 1 - (elapsed / duration)
        local offsetX = math.sin(elapsed * 50) * intensity * decay
        local offsetY = math.cos(elapsed * 40) * intensity * decay
        
        object.Position = originalPosition + UDim2.new(0, offsetX, 0, offsetY)
    end)
end

function Animation.Stop(object)
    if Animation.ActiveTweens[object] then
        Animation.ActiveTweens[object]:Cancel()
        Animation.ActiveTweens[object] = nil
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Utility Functions
-- ═══════════════════════════════════════════════════════════════════════════════

local Utility = {}

function Utility.Create(className, properties)
    local instance = Instance.new(className)
    
    if properties then
        for key, value in pairs(properties) do
            if key ~= "Parent" then
                instance[key] = value
            end
        end
    end
    
    return instance
end

function Utility.ApplyCorner(instance, radius)
    radius = radius or CONSTANTS.CORNER_MEDIUM
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

function Utility.ApplyStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(75, 85, 99)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = instance
    return stroke
end

function Utility.ApplyShadow(instance, offset, blur, color)
    offset = offset or 4
    blur = blur or 12
    color = color or Color3.fromRGB(0, 0, 0)
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13160452137" -- Shadow image
    shadow.ImageColor3 = color
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(50, 50, 50, 50)
    shadow.SliceScale = 0.1
    shadow.Size = UDim2.new(1, blur * 2, 1, blur * 2)
    shadow.Position = UDim2.new(0, -blur + offset, 0, -blur + offset)
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Parent = instance
    
    return shadow
end

function Utility.ApplyPadding(instance, padding)
    padding = padding or CONSTANTS.PADDING_MEDIUM
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, padding)
    uiPadding.PaddingRight = UDim.new(0, padding)
    uiPadding.PaddingTop = UDim.new(0, padding)
    uiPadding.PaddingBottom = UDim.new(0, padding)
    uiPadding.Parent = instance
    return uiPadding
end

function Utility.ApplyListLayout(instance, padding, direction, alignment)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or CONSTANTS.PADDING_MEDIUM)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = instance
    return layout
end

function Utility.ApplySizeConstraint(instance, minSize, maxSize)
    local constraint = Instance.new("UISizeConstraint")
    if minSize then
        constraint.MinSize = minSize
    end
    if maxSize then
        constraint.MaxSize = maxSize
    end
    constraint.Parent = instance
    return constraint
end

function Utility.ApplyAspectRatio(instance, ratio, axis)
    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = ratio or 1
    aspect.AspectType = Enum.AspectType.FitWithinMaxSize
    aspect.DominantAxis = axis or Enum.DominantAxis.Width
    aspect.Parent = instance
    return aspect
end

function Utility.GetTextSize(text, fontSize, font, maxWidth)
    return TextService:GetTextSize(
        text,
        fontSize,
        font or Enum.Font.Gotham,
        Vector2.new(maxWidth or 1000, 1000)
    )
end

function Utility.IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function Utility.IsTablet()
    local viewport = workspace.CurrentCamera.ViewportSize
    return viewport.X >= 768 and viewport.Y >= 1024
end

function Utility.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utility.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utility.Map(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

function Utility.GenerateId()
    return tostring(tick()) .. tostring(math.random(1000, 9999))
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Event System
-- ═══════════════════════════════════════════════════════════════════════════════

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self.connections = {}
    self._destroyed = false
    return self
end

function Signal:Connect(callback)
    if self._destroyed then return {Disconnect = function() end} end
    
    local connection = {
        callback = callback,
        connected = true
    }
    
    table.insert(self.connections, connection)
    
    return {
        Disconnect = function()
            connection.connected = false
            for i, conn in ipairs(self.connections) do
                if conn == connection then
                    table.remove(self.connections, i)
                    break
                end
            end
        end
    }
end

function Signal:Fire(...)
    if self._destroyed then return end
    
    for _, connection in ipairs(table.clone(self.connections)) do
        if connection.connected then
            task.spawn(connection.callback, ...)
        end
    end
end

function Signal:Wait()
    if self._destroyed then return end
    
    local thread = coroutine.running()
    local connection
    connection = self:Connect(function(...)
        connection:Disconnect()
        task.spawn(thread, ...)
    end)
    return coroutine.yield()
end

function Signal:Destroy()
    self._destroyed = true
    self.connections = {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Base Component Class
-- ═══════════════════════════════════════════════════════════════════════════════

local Component = {}
Component.__index = Component

function Component.new(props)
    local self = setmetatable({}, Component)
    
    self.Id = Utility.GenerateId()
    self.Theme = props.Theme or Theme.new("Dark")
    self.Instance = nil
    self.Children = {}
    self.Connections = {}
    self._destroyed = false
    self._state = {}
    self._stateCallbacks = {}
    
    -- Events
    self.OnHover = Signal.new()
    self.OnLeave = Signal.new()
    self.OnPressed = Signal.new()
    self.OnReleased = Signal.new()
    
    return self
end

function Component:SetState(key, value)
    local oldValue = self._state[key]
    self._state[key] = value
    
    if oldValue ~= value and self._stateCallbacks[key] then
        for _, callback in ipairs(self._stateCallbacks[key]) do
            callback(value, oldValue)
        end
    end
end

function Component:GetState(key)
    return self._state[key]
end

function Component:OnStateChange(key, callback)
    if not self._stateCallbacks[key] then
        self._stateCallbacks[key] = {}
    end
    table.insert(self._stateCallbacks[key], callback)
end

function Component:AddChild(child)
    table.insert(self.Children, child)
    if child.Instance and self.Instance then
        child.Instance.Parent = self.Instance
    end
end

function Component:Connect(event, callback)
    if typeof(event) == "RBXScriptSignal" then
        local connection = event:Connect(callback)
        table.insert(self.Connections, connection)
        return connection
    end
    return nil
end

function Component:SetupInteractions()
    if not self.Instance then return end
    
    local isPressed = false
    local isHovered = false
    
    self:Connect(self.Instance.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            isHovered = true
            self:SetState("Hovered", true)
            self.OnHover:Fire()
            self:UpdateVisualState()
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
            isPressed = true
            self:SetState("Pressed", true)
            self.OnPressed:Fire()
            self:UpdateVisualState()
        end
    end)
    
    self:Connect(self.Instance.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            isHovered = false
            self:SetState("Hovered", false)
            self.OnLeave:Fire()
            self:UpdateVisualState()
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
            isPressed = false
            self:SetState("Pressed", false)
            self.OnReleased:Fire()
            self:UpdateVisualState()
        end
    end)
end

function Component:UpdateVisualState()
    -- Override in subclasses
end

function Component:SetParent(parent)
    if self.Instance then
        self.Instance.Parent = parent
    end
end

function Component:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    
    -- Disconnect all connections
    for _, connection in ipairs(self.Connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    self.Connections = {}
    
    -- Destroy all children
    for _, child in ipairs(self.Children) do
        if typeof(child.Destroy) == "function" then
            child:Destroy()
        end
    end
    self.Children = {}
    
    -- Destroy signals
    self.OnHover:Destroy()
    self.OnLeave:Destroy()
    self.OnPressed:Destroy()
    self.OnReleased:Destroy()
    
    -- Destroy instance
    if self.Instance then
        self.Instance:Destroy()
        self.Instance = nil
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Window System
-- ═══════════════════════════════════════════════════════════════════════════════

local Window = {}
Window.__index = Window
setmetatable(Window, Component)

function Window.new(props)
    local self = setmetatable(Component.new(props), Window)
    
    props = props or {}
    self.Title = props.Title or "Aurora Window"
    self.Size = props.Size or UDim2.new(0, 400, 0, 300)
    self.Position = props.Position or UDim2.new(0.5, -200, 0.5, -150)
    self.MinSize = props.MinSize or Vector2.new(CONSTANTS.WINDOW_MIN_WIDTH, CONSTANTS.WINDOW_MIN_HEIGHT)
    self.MaxSize = props.MaxSize or Vector2.new(800, 600)
    self.Resizable = props.Resizable ~= false
    self.Draggable = props.Draggable ~= false
    self.Collapsible = props.Collapsible ~= false
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self._isCollapsed = false
    self._isDragging = false
    self._isResizing = false
    self._dragStart = nil
    self._resizeStart = nil
    self._originalSize = nil
    self._originalPosition = nil
    
    self:Build()
    return self
end

function Window:Build()
    -- Main container
    self.Instance = Utility.Create("Frame", {
        Name = "Window_" .. self.Id,
        Size = self.Size,
        Position = self.Position,
        BackgroundColor3 = self.Theme:GetColor("Background"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = CONSTANTS.LAYER_WINDOW,
    })
    
    Utility.ApplyCorner(self.Instance, CONSTANTS.CORNER_LARGE)
    Utility.ApplyStroke(self.Instance, self.Theme:GetColor("Border"), 1, 0.5)
    Utility.ApplyShadow(self.Instance, 4, 20)
    
    -- Title bar
    self.TitleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, CONSTANTS.TITLE_BAR_HEIGHT),
        BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    Utility.ApplyCorner(self.TitleBar, CONSTANTS.CORNER_MEDIUM)
    
    -- Fix corners - mask bottom corners of title bar
    local titleBarMask = Utility.Create("Frame", {
        Name = "Mask",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ZIndex = self.TitleBar.ZIndex,
        Parent = self.TitleBar,
    })
    
    -- Title text
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = self.Theme:GetColor("TextPrimary"),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = self.TitleBar.ZIndex + 1,
        Parent = self.TitleBar,
    })
    
    -- Control buttons container
    local controlsContainer = Utility.Create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -65, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = self.TitleBar.ZIndex + 1,
        Parent = self.TitleBar,
    })
    
    Utility.ApplyListLayout(controlsContainer, 4, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right)
    
    -- Collapse button
    if self.Collapsible then
        self.CollapseButton = self:CreateControlButton(controlsContainer, "−", function()
            self:ToggleCollapse()
        end)
    end
    
    -- Close button
    self.CloseButton = self:CreateControlButton(controlsContainer, "×", function()
        self:Close()
    end, self.Theme:GetColor("Error"))
    
    -- Content container
    self.Content = Utility.Create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -CONSTANTS.TITLE_BAR_HEIGHT),
        Position = UDim2.new(0, 0, 0, CONSTANTS.TITLE_BAR_HEIGHT),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme:GetColor("Surface"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = self.Instance.ZIndex,
        Parent = self.Instance,
    })
    
    Utility.ApplyPadding(self.Content, CONSTANTS.PADDING_LARGE)
    Utility.ApplyListLayout(self.Content, CONSTANTS.PADDING_MEDIUM)
    
    -- Resize handle
    if self.Resizable then
        self.ResizeHandle = Utility.Create("Frame", {
            Name = "ResizeHandle",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -16, 1, -16),
            BackgroundTransparency = 1,
            ZIndex = self.Instance.ZIndex + 10,
            Parent = self.Instance,
        })
        
        local resizeIcon = Utility.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://13160452138", -- Resize icon
            ImageColor3 = self.Theme:GetColor("TextTertiary"),
            ZIndex = self.ResizeHandle.ZIndex,
            Parent = self.ResizeHandle,
        })
    end
    
    -- Setup interactions
    self:SetupWindowInteractions()
    
    -- Theme change listener
    self.ThemeConnection = self.Theme:OnChange(function(key, value)
        self:UpdateTheme()
    end)
end

function Window:CreateControlButton(parent, text, callback, hoverColor)
    local button = Utility.Create("TextButton", {
        Name = "ControlButton",
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = self.Theme:GetColor("TextSecondary"),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        ZIndex = parent.ZIndex + 1,
        Parent = parent,
    })
    
    local originalColor = self.Theme:GetColor("TextSecondary")
    hoverColor = hoverColor or self.Theme:GetColor("TextPrimary")
    
    button.MouseEnter:Connect(function()
        Animation.Tween(button, {TextColor3 = hoverColor}, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Animation.Tween(button, {TextColor3 = originalColor}, 0.15)
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function Window:SetupWindowInteractions()
    if self.Draggable then
        self.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                self._isDragging = true
                self._dragStart = input.Position
                self._originalPosition = self.Instance.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        self._isDragging = false
                    end
                end)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if self._isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                                     input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - self._dragStart
                local newPosition = UDim2.new(
                    self._originalPosition.X.Scale,
                    self._originalPosition.X.Offset + delta.X,
                    self._originalPosition.Y.Scale,
                    self._originalPosition.Y.Offset + delta.Y
                )
                self.Instance.Position = newPosition
            end
        end)
    end
    
    if self.Resizable and self.ResizeHandle then
        self.ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                self._isResizing = true
                self._resizeStart = input.Position
                self._originalSize = self.Instance.Size
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        self._isResizing = false
                    end
                end)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if self._isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                                     input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - self._resizeStart
                local newWidth = math.clamp(
                    self._originalSize.X.Offset + delta.X,
                    self.MinSize.X,
                    self.MaxSize.X
                )
                local newHeight = math.clamp(
                    self._originalSize.Y.Offset + delta.Y,
                    self.MinSize.Y,
                    self.MaxSize.Y
                )
                self.Instance.Size = UDim2.new(0, newWidth, 0, newHeight)
            end
        end)
    end
end

function Window:ToggleCollapse()
    self._isCollapsed = not self._isCollapsed
    
    if self._isCollapsed then
        self._expandedSize = self.Instance.Size
        Animation.Tween(self.Instance, {
            Size = UDim2.new(0, self.Instance.Size.X.Offset, 0, CONSTANTS.TITLE_BAR_HEIGHT)
        }, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT)
        self.Content.Visible = false
        if self.ResizeHandle then
            self.ResizeHandle.Visible = false
        end
    else
        self.Content.Visible = true
        Animation.Tween(self.Instance, {
            Size = self._expandedSize
        }, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT, function()
            if self.ResizeHandle then
                self.ResizeHandle.Visible = true
            end
        end)
    end
end

function Window:UpdateTheme()
    if not self.Instance then return end
    
    self.Instance.BackgroundColor3 = self.Theme:GetColor("Background")
    Utility.ApplyStroke(self.Instance, self.Theme:GetColor("Border"), 1, 0.5)
    
    self.TitleBar.BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary")
    self.TitleLabel.TextColor3 = self.Theme:GetColor("TextPrimary")
    self.Content.ScrollBarImageColor3 = self.Theme:GetColor("Surface")
end

function Window:AddComponent(component)
    if component.Instance then
        component.Instance.Parent = self.Content
    end
    self:AddChild(component)
    return component
end

function Window:Show()
    self.Instance.Visible = true
    Animation.FadeIn(self.Instance, CONSTANTS.ANIMATION_NORMAL)
    Animation.ScaleIn(self.Instance, CONSTANTS.ANIMATION_NORMAL)
end

function Window:Hide()
    Animation.FadeOut(self.Instance, CONSTANTS.ANIMATION_NORMAL, function()
        self.Instance.Visible = false
    end)
end

function Window:Close()
    Animation.Tween(self.Instance, {Size = UDim2.new(0, 0, 0, 0)}, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT, function()
        self:Destroy()
    end)
end

function Window:SetTitle(title)
    self.Title = title
    self.TitleLabel.Text = title
end

function Window:Destroy()
    if self.ThemeConnection then
        self.ThemeConnection()
    end
    Component.Destroy(self)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Button Component
-- ═══════════════════════════════════════════════════════════════════════════════

local Button = {}
Button.__index = Button
setmetatable(Button, Component)

function Button.new(props)
    local self = setmetatable(Component.new(props), Button)
    
    props = props or {}
    self.Text = props.Text or "Button"
    self.Style = props.Style or "Primary" -- Primary, Secondary, Ghost, Danger
    self.Size = props.Size or UDim2.new(1, 0, 0, CONSTANTS.COMPONENT_HEIGHT)
    self.Icon = props.Icon
    self.Callback = props.Callback or function() end
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self:Build()
    return self
end

function Button:Build()
    self.Instance = Utility.Create("TextButton", {
        Name = "Button_" .. self.Id,
        Size = self.Size,
        BackgroundColor3 = self:GetBackgroundColor(),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10,
    })
    
    Utility.ApplyCorner(self.Instance, CONSTANTS.CORNER_MEDIUM)
    
    -- Icon
    if self.Icon then
        self.IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = self.Icon,
            ImageColor3 = self:GetTextColor(),
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
    end
    
    -- Text
    self.TextLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, self.Icon and -40 or -24, 1, 0),
        Position = UDim2.new(0, self.Icon and 36 or 12, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Text,
        TextColor3 = self:GetTextColor(),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    -- Setup interactions
    self:SetupButtonInteractions()
end

function Button:GetBackgroundColor()
    local colors = {
        Primary = self.Theme:GetColor("Primary"),
        Secondary = self.Theme:GetColor("Surface"),
        Ghost = self.Theme:GetColor("BackgroundTertiary"),
        Danger = self.Theme:GetColor("Error"),
    }
    return colors[self.Style] or colors.Primary
end

function Button:GetTextColor()
    if self.Style == "Primary" or self.Style == "Danger" then
        return Color3.fromRGB(255, 255, 255)
    end
    return self.Theme:GetColor("TextPrimary")
end

function Button:SetupButtonInteractions()
    local originalColor = self.Instance.BackgroundColor3
    local hoverColor = self:GetHoverColor()
    local pressedColor = self:GetPressedColor()
    
    self.Instance.MouseEnter:Connect(function()
        Animation.Tween(self.Instance, {BackgroundColor3 = hoverColor}, CONSTANTS.ANIMATION_FAST)
    end)
    
    self.Instance.MouseLeave:Connect(function()
        Animation.Tween(self.Instance, {BackgroundColor3 = originalColor}, CONSTANTS.ANIMATION_FAST)
    end)
    
    self.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            Animation.Tween(self.Instance, {BackgroundColor3 = pressedColor}, CONSTANTS.ANIMATION_FAST)
        end
    end)
    
    self.Instance.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            Animation.Tween(self.Instance, {BackgroundColor3 = hoverColor}, CONSTANTS.ANIMATION_FAST)
            self.Callback()
        end
    end)
end

function Button:GetHoverColor()
    local colors = {
        Primary = self.Theme:GetColor("PrimaryHover"),
        Secondary = self.Theme:GetColor("SurfaceHover"),
        Ghost = self.Theme:GetColor("Surface"),
        Danger = self.Theme:GetColor("Error"),
    }
    return colors[self.Style] or colors.Primary
end

function Button:GetPressedColor()
    local colors = {
        Primary = self.Theme:GetColor("PrimaryPressed"),
        Secondary = self.Theme:GetColor("SurfacePressed"),
        Ghost = self.Theme:GetColor("SurfaceHover"),
        Danger = self.Theme:GetColor("Error"),
    }
    return colors[self.Style] or colors.Primary
end

function Button:SetText(text)
    self.Text = text
    self.TextLabel.Text = text
end

function Button:SetCallback(callback)
    self.Callback = callback
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: iOS Switch/Toggle Component
-- ═══════════════════════════════════════════════════════════════════════════════

local Switch = {}
Switch.__index = Switch
setmetatable(Switch, Component)

function Switch.new(props)
    local self = setmetatable(Component.new(props), Switch)
    
    props = props or {}
    self.Label = props.Label or ""
    self.Value = props.Value or false
    self.Callback = props.Callback or function() end
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self.OnChanged = Signal.new()
    
    self:Build()
    return self
end

function Switch:Build()
    self.Instance = Utility.Create("Frame", {
        Name = "Switch_" .. self.Id,
        Size = UDim2.new(1, 0, 0, CONSTANTS.COMPONENT_HEIGHT),
        BackgroundTransparency = 1,
        ZIndex = 10,
    })
    
    -- Label
    if self.Label ~= "" then
        self.LabelText = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -60, 1, 0),
            BackgroundTransparency = 1,
            Text = self.Label,
            TextColor3 = self.Theme:GetColor("TextPrimary"),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
    end
    
    -- Switch container
    self.SwitchContainer = Utility.Create("TextButton", {
        Name = "SwitchContainer",
        Size = UDim2.new(0, 48, 0, 26),
        Position = UDim2.new(1, -48, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.Value and self.Theme:GetColor("Primary") or self.Theme:GetColor("Surface"),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    Utility.ApplyCorner(self.SwitchContainer, 13)
    
    -- Thumb
    self.Thumb = Utility.Create("Frame", {
        Name = "Thumb",
        Size = UDim2.new(0, 20, 0, 20),
        Position = self.Value and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = self.SwitchContainer.ZIndex + 1,
        Parent = self.SwitchContainer,
    })
    
    Utility.ApplyCorner(self.Thumb, 10)
    
    -- Add subtle shadow to thumb
    local thumbShadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://13160452137",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(50, 50, 50, 50),
        SliceScale = 0.1,
        ZIndex = self.Thumb.ZIndex - 1,
        Parent = self.Thumb,
    })
    
    -- Setup interactions
    self:SetupSwitchInteractions()
end

function Switch:SetupSwitchInteractions()
    self.SwitchContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            self:Toggle()
        end
    end)
end

function Switch:Toggle()
    self.Value = not self.Value
    
    -- Animate thumb position
    local targetPosition = self.Value and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    Animation.Tween(self.Thumb, {Position = targetPosition}, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT)
    
    -- Animate background color
    local targetColor = self.Value and self.Theme:GetColor("Primary") or self.Theme:GetColor("Surface")
    Animation.Tween(self.SwitchContainer, {BackgroundColor3 = targetColor}, CONSTANTS.ANIMATION_NORMAL)
    
    -- Fire callbacks
    self.OnChanged:Fire(self.Value)
    self.Callback(self.Value)
end

function Switch:SetValue(value)
    if self.Value ~= value then
        self.Value = value
        
        local targetPosition = self.Value and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        self.Thumb.Position = targetPosition
        
        local targetColor = self.Value and self.Theme:GetColor("Primary") or self.Theme:GetColor("Surface")
        self.SwitchContainer.BackgroundColor3 = targetColor
    end
end

function Switch:GetValue()
    return self.Value
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Slider Component
-- ═══════════════════════════════════════════════════════════════════════════════

local Slider = {}
Slider.__index = Slider
setmetatable(Slider, Component)

function Slider.new(props)
    local self = setmetatable(Component.new(props), Slider)
    
    props = props or {}
    self.Label = props.Label or "Slider"
    self.Min = props.Min or 0
    self.Max = props.Max or 100
    self.Value = props.Value or self.Min
    self.Step = props.Step or 1
    self.ShowValue = props.ShowValue ~= false
    self.Suffix = props.Suffix or ""
    self.Callback = props.Callback or function() end
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self.OnChanged = Signal.new()
    self._isDragging = false
    
    self:Build()
    return self
end

function Slider:Build()
    self.Instance = Utility.Create("Frame", {
        Name = "Slider_" .. self.Id,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 10,
    })
    
    -- Label container
    local labelContainer = Utility.Create("Frame", {
        Name = "LabelContainer",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    -- Label
    self.LabelText = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, self.ShowValue and -50 or 0, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Label,
        TextColor3 = self.Theme:GetColor("TextPrimary"),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = labelContainer.ZIndex,
        Parent = labelContainer,
    })
    
    -- Value display
    if self.ShowValue then
        self.ValueLabel = Utility.Create("TextLabel", {
            Name = "Value",
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(1, -50, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(self.Value) .. self.Suffix,
            TextColor3 = self.Theme:GetColor("TextSecondary"),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = labelContainer.ZIndex,
            Parent = labelContainer,
        })
    end
    
    -- Track container
    local trackContainer = Utility.Create("Frame", {
        Name = "TrackContainer",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    -- Background track
    self.Track = Utility.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.Theme:GetColor("Surface"),
        BorderSizePixel = 0,
        ZIndex = trackContainer.ZIndex,
        Parent = trackContainer,
    })
    
    Utility.ApplyCorner(self.Track, 3)
    
    -- Fill track
    self.Fill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = self.Theme:GetColor("Primary"),
        BorderSizePixel = 0,
        ZIndex = self.Track.ZIndex + 1,
        Parent = self.Track,
    })
    
    Utility.ApplyCorner(self.Fill, 3)
    
    -- Thumb
    self.Thumb = Utility.Create("TextButton", {
        Name = "Thumb",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = self.Fill.ZIndex + 1,
        Parent = trackContainer,
    })
    
    Utility.ApplyCorner(self.Thumb, 9)
    
    -- Thumb shadow
    local thumbShadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 8, 1, 8),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://13160452137",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(50, 50, 50, 50),
        SliceScale = 0.1,
        ZIndex = self.Thumb.ZIndex - 1,
        Parent = self.Thumb,
    })
    
    -- Setup interactions
    self:SetupSliderInteractions()
    
    -- Set initial value
    self:SetValue(self.Value, true)
end

function Slider:SetupSliderInteractions()
    local function updateValueFromInput(input)
        local trackAbsolute = self.Track.AbsolutePosition.X
        local trackWidth = self.Track.AbsoluteSize.X
        local relativeX = input.Position.X - trackAbsolute
        local percentage = math.clamp(relativeX / trackWidth, 0, 1)
        
        local rawValue = self.Min + (self.Max - self.Min) * percentage
        local steppedValue = math.floor((rawValue - self.Min) / self.Step + 0.5) * self.Step + self.Min
        self:SetValue(steppedValue)
    end
    
    self.Thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            self._isDragging = true
            Animation.Tween(self.Thumb, {Size = UDim2.new(0, 22, 0, 22)}, CONSTANTS.ANIMATION_FAST)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self._isDragging = false
                    Animation.Tween(self.Thumb, {Size = UDim2.new(0, 18, 0, 18)}, CONSTANTS.ANIMATION_FAST)
                end
            end)
        end
    end)
    
    self.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            updateValueFromInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self._isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                                 input.UserInputType == Enum.UserInputType.Touch) then
            updateValueFromInput(input)
        end
    end)
end

function Slider:SetValue(value, instant)
    value = Utility.Clamp(value, self.Min, self.Max)
    self.Value = value
    
    local percentage = (value - self.Min) / (self.Max - self.Min)
    
    if instant then
        self.Fill.Size = UDim2.new(percentage, 0, 1, 0)
        self.Thumb.Position = UDim2.new(percentage, 0, 0.5, 0)
    else
        Animation.Tween(self.Fill, {Size = UDim2.new(percentage, 0, 1, 0)}, CONSTANTS.ANIMATION_FAST)
        Animation.Tween(self.Thumb, {Position = UDim2.new(percentage, 0, 0.5, 0)}, CONSTANTS.ANIMATION_FAST)
    end
    
    if self.ValueLabel then
        self.ValueLabel.Text = tostring(value) .. self.Suffix
    end
    
    self.OnChanged:Fire(value)
    self.Callback(value)
end

function Slider:GetValue()
    return self.Value
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Text Input Component
-- ═══════════════════════════════════════════════════════════════════════════════

local TextInput = {}
TextInput.__index = TextInput
setmetatable(TextInput, Component)

function TextInput.new(props)
    local self = setmetatable(Component.new(props), TextInput)
    
    props = props or {}
    self.Label = props.Label or ""
    self.Placeholder = props.Placeholder or "Enter text..."
    self.Value = props.Value or ""
    self.ClearOnFocus = props.ClearOnFocus or false
    self.Callback = props.Callback or function() end
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self.OnChanged = Signal.new()
    self.OnFocus = Signal.new()
    self.OnFocusLost = Signal.new()
    
    self:Build()
    return self
end

function TextInput:Build()
    local totalHeight = self.Label ~= "" and 60 or 36
    
    self.Instance = Utility.Create("Frame", {
        Name = "TextInput_" .. self.Id,
        Size = UDim2.new(1, 0, 0, totalHeight),
        BackgroundTransparency = 1,
        ZIndex = 10,
    })
    
    local offset = 0
    
    -- Label
    if self.Label ~= "" then
        self.LabelText = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = self.Label,
            TextColor3 = self.Theme:GetColor("TextPrimary"),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
        offset = 24
    end
    
    -- Input container
    self.InputContainer = Utility.Create("Frame", {
        Name = "InputContainer",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, offset),
        BackgroundColor3 = self.Theme:GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    Utility.ApplyCorner(self.InputContainer, CONSTANTS.CORNER_MEDIUM)
    Utility.ApplyStroke(self.InputContainer, self.Theme:GetColor("Border"), 1, 0.5)
    
    -- TextBox
    self.TextBox = Utility.Create("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Value,
        PlaceholderText = self.Placeholder,
        PlaceholderColor3 = self.Theme:GetColor("TextTertiary"),
        TextColor3 = self.Theme:GetColor("TextPrimary"),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = self.ClearOnFocus,
        ZIndex = self.InputContainer.ZIndex + 1,
        Parent = self.InputContainer,
    })
    
    -- Setup interactions
    self:SetupInputInteractions()
end

function TextInput:SetupInputInteractions()
    self.TextBox.Focused:Connect(function()
        Animation.Tween(self.InputContainer, {BackgroundColor3 = self.Theme:GetColor("Surface")}, CONSTANTS.ANIMATION_FAST)
        Utility.ApplyStroke(self.InputContainer, self.Theme:GetColor("Primary"), 1.5, 0)
        self.OnFocus:Fire()
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        Animation.Tween(self.InputContainer, {BackgroundColor3 = self.Theme:GetColor("BackgroundTertiary")}, CONSTANTS.ANIMATION_FAST)
        Utility.ApplyStroke(self.InputContainer, self.Theme:GetColor("Border"), 1, 0.5)
        self.Value = self.TextBox.Text
        self.OnFocusLost:Fire(enterPressed, self.Value)
        self.Callback(self.Value, enterPressed)
    end)
    
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.Value = self.TextBox.Text
        self.OnChanged:Fire(self.Value)
    end)
end

function TextInput:SetValue(value)
    self.Value = value
    self.TextBox.Text = value
end

function TextInput:GetValue()
    return self.Value
end

function TextInput:Focus()
    self.TextBox:CaptureFocus()
end

function TextInput:ReleaseFocus()
    self.TextBox:ReleaseFocus()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Dropdown Component
-- ═══════════════════════════════════════════════════════════════════════════════

local Dropdown = {}
Dropdown.__index = Dropdown
setmetatable(Dropdown, Component)

function Dropdown.new(props)
    local self = setmetatable(Component.new(props), Dropdown)
    
    props = props or {}
    self.Label = props.Label or ""
    self.Options = props.Options or {}
    self.Selected = props.Selected or (self.Options[1] or "")
    self.Placeholder = props.Placeholder or "Select..."
    self.Callback = props.Callback or function() end
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self.OnChanged = Signal.new()
    self._isOpen = false
    
    self:Build()
    return self
end

function Dropdown:Build()
    local totalHeight = self.Label ~= "" and 60 or 36
    
    self.Instance = Utility.Create("Frame", {
        Name = "Dropdown_" .. self.Id,
        Size = UDim2.new(1, 0, 0, totalHeight),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        ZIndex = 10,
    })
    
    local offset = 0
    
    -- Label
    if self.Label ~= "" then
        self.LabelText = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = self.Label,
            TextColor3 = self.Theme:GetColor("TextPrimary"),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
        offset = 24
    end
    
    -- Dropdown button
    self.DropdownButton = Utility.Create("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, offset),
        BackgroundColor3 = self.Theme:GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    Utility.ApplyCorner(self.DropdownButton, CONSTANTS.CORNER_MEDIUM)
    Utility.ApplyStroke(self.DropdownButton, self.Theme:GetColor("Border"), 1, 0.5)
    
    -- Selected text
    self.SelectedText = Utility.Create("TextLabel", {
        Name = "SelectedText",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Selected ~= "" and self.Selected or self.Placeholder,
        TextColor3 = self.Selected ~= "" and self.Theme:GetColor("TextPrimary") or self.Theme:GetColor("TextTertiary"),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = self.DropdownButton.ZIndex + 1,
        Parent = self.DropdownButton,
    })
    
    -- Arrow icon
    self.ArrowIcon = Utility.Create("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -26, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://13160452139", -- Chevron down
        ImageColor3 = self.Theme:GetColor("TextSecondary"),
        Rotation = 0,
        ZIndex = self.DropdownButton.ZIndex + 1,
        Parent = self.DropdownButton,
    })
    
    -- Options container (initially hidden)
    self.OptionsContainer = Utility.Create("Frame", {
        Name = "OptionsContainer",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = self.DropdownButton.ZIndex + 10,
        Parent = self.DropdownButton,
    })
    
    Utility.ApplyCorner(self.OptionsContainer, CONSTANTS.CORNER_MEDIUM)
    Utility.ApplyStroke(self.OptionsContainer, self.Theme:GetColor("Border"), 1, 0.5)
    Utility.ApplyShadow(self.OptionsContainer, 0, 15)
    
    local optionsList = Utility.Create("ScrollingFrame", {
        Name = "OptionsList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme:GetColor("Surface"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = self.OptionsContainer.ZIndex,
        Parent = self.OptionsContainer,
    })
    
    Utility.ApplyPadding(optionsList, CONSTANTS.PADDING_SMALL)
    Utility.ApplyListLayout(optionsList, CONSTANTS.PADDING_SMALL)
    
    self.OptionsList = optionsList
    
    -- Populate options
    self:PopulateOptions()
    
    -- Setup interactions
    self:SetupDropdownInteractions()
end

function Dropdown:PopulateOptions()
    for _, option in ipairs(self.Options) do
        self:CreateOptionButton(option)
    end
end

function Dropdown:CreateOptionButton(optionText)
    local optionButton = Utility.Create("TextButton", {
        Name = "Option_" .. optionText,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = self.OptionsList.ZIndex + 1,
        Parent = self.OptionsList,
    })
    
    Utility.ApplyCorner(optionButton, CONSTANTS.CORNER_SMALL)
    
    local optionLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = optionText,
        TextColor3 = self.Theme:GetColor("TextPrimary"),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = optionButton.ZIndex,
        Parent = optionButton,
    })
    
    optionButton.MouseEnter:Connect(function()
        Animation.Tween(optionButton, {BackgroundColor3 = self.Theme:GetColor("Surface")}, CONSTANTS.ANIMATION_FAST)
    end)
    
    optionButton.MouseLeave:Connect(function()
        Animation.Tween(optionButton, {BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary")}, CONSTANTS.ANIMATION_FAST)
    end)
    
    optionButton.MouseButton1Click:Connect(function()
        self:SelectOption(optionText)
        self:Close()
    end)
end

function Dropdown:SetupDropdownInteractions()
    self.DropdownButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Close when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if self._isOpen then
                local mousePos = UserInputService:GetMouseLocation()
                local containerPos = self.OptionsContainer.AbsolutePosition
                local containerSize = self.OptionsContainer.AbsoluteSize
                
                if mousePos.X < containerPos.X or mousePos.X > containerPos.X + containerSize.X or
                   mousePos.Y < containerPos.Y or mousePos.Y > containerPos.Y + containerSize.Y then
                    local buttonPos = self.DropdownButton.AbsolutePosition
                    local buttonSize = self.DropdownButton.AbsoluteSize
                    
                    if mousePos.X < buttonPos.X or mousePos.X > buttonPos.X + buttonSize.X or
                       mousePos.Y < buttonPos.Y or mousePos.Y > buttonPos.Y + buttonSize.Y then
                        self:Close()
                    end
                end
            end
        end
    end)
end

function Dropdown:Toggle()
    if self._isOpen then
        self:Close()
    else
        self:Open()
    end
end

function Dropdown:Open()
    self._isOpen = true
    
    -- Calculate height based on options
    local optionHeight = 32
    local padding = 8
    local maxHeight = 200
    local targetHeight = math.min(#self.Options * (optionHeight + padding) + padding, maxHeight)
    
    self.OptionsContainer.Visible = true
    Animation.Tween(self.OptionsContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT)
    Animation.Tween(self.ArrowIcon, {Rotation = 180}, CONSTANTS.ANIMATION_NORMAL)
end

function Dropdown:Close()
    self._isOpen = false
    
    Animation.Tween(self.OptionsContainer, {Size = UDim2.new(1, 0, 0, 0)}, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT, function()
        self.OptionsContainer.Visible = false
    end)
    Animation.Tween(self.ArrowIcon, {Rotation = 0}, CONSTANTS.ANIMATION_NORMAL)
end

function Dropdown:SelectOption(option)
    self.Selected = option
    self.SelectedText.Text = option
    self.SelectedText.TextColor3 = self.Theme:GetColor("TextPrimary")
    
    self.OnChanged:Fire(option)
    self.Callback(option)
end

function Dropdown:SetOptions(options)
    self.Options = options
    
    -- Clear existing options
    for _, child in ipairs(self.OptionsList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Repopulate
    self:PopulateOptions()
end

function Dropdown:GetSelected()
    return self.Selected
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Label Component
-- ═══════════════════════════════════════════════════════════════════════════════

local Label = {}
Label.__index = Label
setmetatable(Label, Component)

function Label.new(props)
    local self = setmetatable(Component.new(props), Label)
    
    props = props or {}
    self.Text = props.Text or "Label"
    self.Style = props.Style or "Normal" -- Normal, Heading, Subheading, Caption
    self.Alignment = props.Alignment or Enum.TextXAlignment.Left
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self:Build()
    return self
end

function Label:Build()
    local fontSize = 13
    local font = Enum.Font.Gotham
    local textColor = self.Theme:GetColor("TextPrimary")
    
    if self.Style == "Heading" then
        fontSize = 18
        font = Enum.Font.GothamBold
    elseif self.Style == "Subheading" then
        fontSize = 15
        font = Enum.Font.GothamSemibold
    elseif self.Style == "Caption" then
        fontSize = 11
        textColor = self.Theme:GetColor("TextSecondary")
    end
    
    self.Instance = Utility.Create("TextLabel", {
        Name = "Label_" .. self.Id,
        Size = UDim2.new(1, 0, 0, fontSize + 8),
        BackgroundTransparency = 1,
        Text = self.Text,
        TextColor3 = textColor,
        TextSize = fontSize,
        Font = font,
        TextXAlignment = self.Alignment,
        ZIndex = 10,
    })
end

function Label:SetText(text)
    self.Text = text
    self.Instance.Text = text
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Section/Divider Component
-- ═══════════════════════════════════════════════════════════════════════════════

local Section = {}
Section.__index = Section
setmetatable(Section, Component)

function Section.new(props)
    local self = setmetatable(Component.new(props), Section)
    
    props = props or {}
    self.Title = props.Title or ""
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self:Build()
    return self
end

function Section:Build()
    self.Instance = Utility.Create("Frame", {
        Name = "Section_" .. self.Id,
        Size = UDim2.new(1, 0, 0, self.Title ~= "" and 30 or 16),
        BackgroundTransparency = 1,
        ZIndex = 10,
    })
    
    if self.Title ~= "" then
        -- Title
        self.TitleLabel = Utility.Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = self.Title,
            TextColor3 = self.Theme:GetColor("TextSecondary"),
            TextSize = 11,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
        
        -- Divider line
        local divider = Utility.Create("Frame", {
            Name = "Divider",
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0, 24),
            BackgroundColor3 = self.Theme:GetColor("Border"),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
    else
        -- Just divider
        local divider = Utility.Create("Frame", {
            Name = "Divider",
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = self.Theme:GetColor("Border"),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
            ZIndex = self.Instance.ZIndex + 1,
            Parent = self.Instance,
        })
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Tab System
-- ═══════════════════════════════════════════════════════════════════════════════

local TabContainer = {}
TabContainer.__index = TabContainer
setmetatable(TabContainer, Component)

function TabContainer.new(props)
    local self = setmetatable(Component.new(props), TabContainer)
    
    props = props or {}
    self.Tabs = {}
    self.ActiveTab = nil
    self.Theme = props.Theme or AuroraUI.CurrentTheme
    
    self.OnTabChanged = Signal.new()
    
    self:Build()
    return self
end

function TabContainer:Build()
    self.Instance = Utility.Create("Frame", {
        Name = "TabContainer_" .. self.Id,
        Size = UDim2.new(1, 0, 0, 300),
        BackgroundTransparency = 1,
        ZIndex = 10,
    })
    
    -- Tab bar
    self.TabBar = Utility.Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ZIndex = self.Instance.ZIndex + 1,
        Parent = self.Instance,
    })
    
    Utility.ApplyCorner(self.TabBar, CONSTANTS.CORNER_MEDIUM)
    
    -- Tab buttons container
    self.TabButtons = Utility.Create("Frame", {
        Name = "TabButtons",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = self.TabBar.ZIndex + 1,
        Parent = self.TabBar,
    })
    
    Utility.ApplyListLayout(self.TabButtons, 0, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left)
    
    -- Indicator
    self.Indicator = Utility.Create("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = self.Theme:GetColor("Primary"),
        BorderSizePixel = 0,
        ZIndex = self.TabBar.ZIndex + 2,
        Parent = self.TabBar,
    })
    
    -- Content container
    self.ContentContainer = Utility.Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1,
        ZIndex = self.Instance.ZIndex,
        Parent = self.Instance,
    })
end

function TabContainer:AddTab(name, content)
    local tab = {
        Name = name,
        Content = content,
        Button = nil,
        ContentFrame = nil,
    }
    
    -- Create tab button
    local button = Utility.Create("TextButton", {
        Name = "Tab_" .. name,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Theme:GetColor("TextSecondary"),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false,
        ZIndex = self.TabButtons.ZIndex + 1,
        Parent = self.TabButtons,
    })
    
    -- Auto-size button based on text
    local textSize = Utility.GetTextSize(name, 13, Enum.Font.GothamSemibold)
    button.Size = UDim2.new(0, textSize.X + 24, 1, 0)
    
    tab.Button = button
    
    -- Create content frame
    local contentFrame = Utility.Create("ScrollingFrame", {
        Name = "Content_" .. name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme:GetColor("Surface"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = self.ContentContainer.ZIndex,
        Parent = self.ContentContainer,
    })
    
    Utility.ApplyPadding(contentFrame, CONSTANTS.PADDING_MEDIUM)
    Utility.ApplyListLayout(contentFrame, CONSTANTS.PADDING_MEDIUM)
    
    tab.ContentFrame = contentFrame
    
    -- Add content
    if content then
        for _, component in ipairs(content) do
            if component.Instance then
                component.Instance.Parent = contentFrame
            end
        end
    end
    
    table.insert(self.Tabs, tab)
    
    -- Button interaction
    button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    button.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            Animation.Tween(button, {TextColor3 = self.Theme:GetColor("TextPrimary")}, CONSTANTS.ANIMATION_FAST)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            Animation.Tween(button, {TextColor3 = self.Theme:GetColor("TextSecondary")}, CONSTANTS.ANIMATION_FAST)
        end
    end)
    
    -- Auto-select first tab
    if #self.Tabs == 1 then
        self:SelectTab(name)
    end
    
    return tab
end

function TabContainer:SelectTab(name)
    for _, tab in ipairs(self.Tabs) do
        if tab.Name == name then
            self.ActiveTab = tab
            
            -- Update button appearance
            Animation.Tween(tab.Button, {TextColor3 = self.Theme:GetColor("TextPrimary")}, CONSTANTS.ANIMATION_FAST)
            
            -- Move indicator
            local buttonPos = tab.Button.Position
            local buttonSize = tab.Button.AbsoluteSize
            Animation.Tween(self.Indicator, {
                Position = UDim2.new(0, tab.Button.AbsolutePosition.X - self.TabButtons.AbsolutePosition.X, 1, -2),
                Size = UDim2.new(0, buttonSize.X, 0, 2)
            }, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT)
            
            -- Show content with fade
            tab.ContentFrame.Visible = true
            tab.ContentFrame.BackgroundTransparency = 1
            Animation.Tween(tab.ContentFrame, {BackgroundTransparency = 0}, CONSTANTS.ANIMATION_NORMAL)
        else
            -- Reset button appearance
            Animation.Tween(tab.Button, {TextColor3 = self.Theme:GetColor("TextSecondary")}, CONSTANTS.ANIMATION_FAST)
            
            -- Hide content
            tab.ContentFrame.Visible = false
        end
    end
    
    self.OnTabChanged:Fire(name)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: Notification System
-- ═══════════════════════════════════════════════════════════════════════════════

local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem

function NotificationSystem.new(theme)
    local self = setmetatable({}, NotificationSystem)
    
    self.Theme = theme or Theme.new("Dark")
    self.Notifications = {}
    self.MaxNotifications = 5
    self.NotificationHeight = 70
    self.NotificationSpacing = 10
    
    self:Build()
    return self
end

function NotificationSystem:Build()
    self.Container = Utility.Create("ScreenGui", {
        Name = "AuroraNotifications",
        DisplayOrder = CONSTANTS.LAYER_NOTIFICATION,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    -- Try to parent to CoreGui or PlayerGui
    pcall(function()
        self.Container.Parent = CoreGui
    end)
    
    if not self.Container.Parent then
        self.Container.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Notifications holder
    self.Holder = Utility.Create("Frame", {
        Name = "Holder",
        Size = UDim2.new(0, 320, 1, -20),
        Position = UDim2.new(1, -340, 0, 10),
        BackgroundTransparency = 1,
        Parent = self.Container,
    })
    
    Utility.ApplyListLayout(self.Holder, self.NotificationSpacing, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right)
end

function NotificationSystem:Notify(props)
    props = props or {}
    
    local title = props.Title or "Notification"
    local message = props.Message or ""
    local duration = props.Duration or 5
    local type = props.Type or "Info" -- Info, Success, Warning, Error
    
    -- Limit notifications
    if #self.Notifications >= self.MaxNotifications then
        self.Notifications[1]:Dismiss()
    end
    
    local notification = self:CreateNotification(title, message, duration, type)
    table.insert(self.Notifications, notification)
    
    return notification
end

function NotificationSystem:CreateNotification(title, message, duration, notificationType)
    local colors = {
        Info = self.Theme:GetColor("Info"),
        Success = self.Theme:GetColor("Success"),
        Warning = self.Theme:GetColor("Warning"),
        Error = self.Theme:GetColor("Error"),
    }
    
    local accentColor = colors[notificationType] or colors.Info
    
    local notification = {}
    notification.Id = Utility.GenerateId()
    notification.Dismissed = false
    
    -- Main frame
    notification.Instance = Utility.Create("Frame", {
        Name = "Notification_" .. notification.Id,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = self.Theme:GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = CONSTANTS.LAYER_NOTIFICATION,
        Parent = self.Holder,
    })
    
    Utility.ApplyCorner(notification.Instance, CONSTANTS.CORNER_MEDIUM)
    Utility.ApplyStroke(notification.Instance, self.Theme:GetColor("Border"), 1, 0.5)
    Utility.ApplyShadow(notification.Instance, 2, 10)
    
    -- Accent bar
    local accentBar = Utility.Create("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = notification.Instance.ZIndex + 1,
        Parent = notification.Instance,
    })
    
    Utility.ApplyCorner(accentBar, 2)
    
    -- Content container
    local content = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        ZIndex = notification.Instance.ZIndex + 1,
        Parent = notification.Instance,
    })
    
    -- Title
    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -24, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme:GetColor("TextPrimary"),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = content.ZIndex,
        Parent = content,
    })
    
    -- Message
    local messageLabel = Utility.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -24, 0, 30),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = self.Theme:GetColor("TextSecondary"),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = content.ZIndex,
        Parent = content,
    })
    
    -- Close button
    local closeButton = Utility.Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = self.Theme:GetColor("TextTertiary"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = content.ZIndex,
        Parent = content,
    })
    
    closeButton.MouseEnter:Connect(function()
        Animation.Tween(closeButton, {TextColor3 = self.Theme:GetColor("TextPrimary")}, CONSTANTS.ANIMATION_FAST)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Animation.Tween(closeButton, {TextColor3 = self.Theme:GetColor("TextTertiary")}, CONSTANTS.ANIMATION_FAST)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        notification:Dismiss()
    end)
    
    -- Progress bar
    local progressBar = Utility.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = notification.Instance.ZIndex + 1,
        Parent = notification.Instance,
    })
    
    local progressFill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = progressBar.ZIndex + 1,
        Parent = progressBar,
    })
    
    -- Animate in
    Animation.Tween(notification.Instance, {Size = UDim2.new(1, 0, 0, self.NotificationHeight)}, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_BACK)
    
    -- Progress animation
    Animation.Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto dismiss
    notification.DismissTimer = task.delay(duration, function()
        notification:Dismiss()
    end)
    
    function notification.Dismiss()
        if notification.Dismissed then return end
        notification.Dismissed = true
        
        if notification.DismissTimer then
            task.cancel(notification.DismissTimer)
        end
        
        -- Remove from list
        for i, notif in ipairs(NotificationSystem.Notifications) do
            if notif.Id == notification.Id then
                table.remove(NotificationSystem.Notifications, i)
                break
            end
        end
        
        -- Animate out
        Animation.Tween(notification.Instance, {Size = UDim2.new(1, 0, 0, 0)}, CONSTANTS.ANIMATION_NORMAL, CONSTANTS.EASE_OUT_QUINT, function()
            notification.Instance:Destroy()
        end)
    end
    
    return notification
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION: AuroraUI Main API
-- ═══════════════════════════════════════════════════════════════════════════════

-- Initialize global theme
AuroraUI.CurrentTheme = Theme.new("Dark")
AuroraUI.NotificationSystem = nil

function AuroraUI:SetTheme(themeName)
    self.CurrentTheme:Apply(themeName)
end

function AuroraUI:GetTheme()
    return self.CurrentTheme
end

function AuroraUI:CreateWindow(props)
    props = props or {}
    props.Theme = props.Theme or self.CurrentTheme
    
    local window = Window.new(props)
    
    -- Parent to appropriate container
    if not self.MainContainer then
        self.MainContainer = Utility.Create("ScreenGui", {
            Name = "AuroraUI",
            DisplayOrder = CONSTANTS.LAYER_WINDOW,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        
        pcall(function()
            self.MainContainer.Parent = CoreGui
        end)
        
        if not self.MainContainer.Parent then
            self.MainContainer.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    
    window.Instance.Parent = self.MainContainer
    window:Show()
    
    return window
end

function AuroraUI:Notify(props)
    if not self.NotificationSystem then
        self.NotificationSystem = NotificationSystem.new(self.CurrentTheme)
    end
    
    return self.NotificationSystem:Notify(props)
end

-- Component factories
function AuroraUI:CreateButton(props)
    props.Theme = props.Theme or self.CurrentTheme
    return Button.new(props)
end

function AuroraUI:CreateSwitch(props)
    props.Theme = props.Theme or self.CurrentTheme
    return Switch.new(props)
end

function AuroraUI:CreateSlider(props)
    props.Theme = props.Theme or self.CurrentTheme
    return Slider.new(props)
end

function AuroraUI:CreateTextInput(props)
    props.Theme = props.Theme or self.CurrentTheme
    return TextInput.new(props)
end

function AuroraUI:CreateDropdown(props)
    props.Theme = props.Theme or self.CurrentTheme
    return Dropdown.new(props)
end

function AuroraUI:CreateLabel(props)
    props.Theme = props.Theme or self.CurrentTheme
    return Label.new(props)
end

function AuroraUI:CreateSection(props)
    props.Theme = props.Theme or self.CurrentTheme
    return Section.new(props)
end

function AuroraUI:CreateTabContainer(props)
    props.Theme = props.Theme or self.CurrentTheme
    return TabContainer.new(props)
end

-- Utility exports
AuroraUI.Theme = Theme
AuroraUI.Animation = Animation
AuroraUI.Utility = Utility
AuroraUI.Constants = CONSTANTS

-- Return the library
return AuroraUI
