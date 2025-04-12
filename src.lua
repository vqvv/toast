local Toast = {}

-- Services
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Theme palettes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Stroke = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(240, 240, 240),
        Icon = Color3.fromRGB(85, 170, 255),
        Progress = Color3.fromRGB(85, 170, 255),
        ProgressBg = Color3.fromRGB(60, 60, 60)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Stroke = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(30, 30, 30),
        Icon = Color3.fromRGB(0, 120, 255),
        Progress = Color3.fromRGB(0, 120, 255),
        ProgressBg = Color3.fromRGB(220, 220, 220)
    }
}

function Toast:CreateToast(message, positionArg, durationArg, themeArg)
    local position = "top"
    local duration = 5
    local theme = Themes.Dark

    -- Flexible parameters
    if type(positionArg) == "number" then
        duration = positionArg
    elseif type(positionArg) == "string" then
        position = positionArg:lower()
        duration = durationArg or duration
    end

    if type(themeArg) == "string" and Themes[themeArg] then
        theme = Themes[themeArg]
    end

    local textSize = TextService:GetTextSize(
        message,
        16,
        Enum.Font.Gotham,
        Vector2.new(300 - 80, math.huge)
    )

    -- GUI Setup
    local ScreenGui = Instance.new("ScreenGui")
    local ToastFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local Container = Instance.new("Frame")
    local Icon = Instance.new("ImageLabel")
    local MessageLabel = Instance.new("TextLabel")
    local ProgressBar = Instance.new("Frame")
    local ProgressFill = Instance.new("Frame")

    ScreenGui.Name = "ToastNotification"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    ToastFrame.Name = "ToastFrame"
    ToastFrame.Parent = ScreenGui
    ToastFrame.AnchorPoint = Vector2.new(0.5, 0)
    ToastFrame.BackgroundColor3 = theme.Background
    ToastFrame.BackgroundTransparency = 1
    ToastFrame.Size = UDim2.new(0, 300, 0, math.max(60, textSize.Y + 50))
    ToastFrame.Position = position == "bottom"
        and UDim2.new(0.5, 0, 1, -ToastFrame.Size.Y.Offset - 10)
        or UDim2.new(0.5, 0, 0, 10)
    ToastFrame.BorderSizePixel = 0
    ToastFrame.ClipsDescendants = true

    UIStroke.Parent = ToastFrame
    UIStroke.Color = theme.Stroke
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.8

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = ToastFrame

    Container.Name = "Container"
    Container.Parent = ToastFrame
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, -20, 1, -20)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)

    Icon.Name = "Icon"
    Icon.Parent = Container
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 0, 0, 0)
    Icon.Image = "rbxassetid://7072716662"
    Icon.ImageColor3 = theme.Icon
    Icon.BackgroundTransparency = 1

    MessageLabel.Name = "MessageLabel"
    MessageLabel.Parent = Container
    MessageLabel.Size = UDim2.new(1, -34, 1, -8)
    MessageLabel.Position = UDim2.new(0, 34, 0, 0)
    MessageLabel.Font = Enum.Font.GothamSemibold
    MessageLabel.Text = message
    MessageLabel.TextColor3 = theme.Text
    MessageLabel.TextSize = 16
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.ZIndex = 2
    MessageLabel.TextTransparency = 1

    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = ToastFrame
    ProgressBar.BackgroundColor3 = theme.ProgressBg
    ProgressBar.Size = UDim2.new(1, -20, 0, 3)
    ProgressBar.Position = UDim2.new(0, 10, 1, -8)
    ProgressBar.AnchorPoint = Vector2.new(0, 1)
    ProgressBar.BorderSizePixel = 0

    ProgressFill.Name = "ProgressFill"
    ProgressFill.Parent = ProgressBar
    ProgressFill.BackgroundColor3 = theme.Progress
    ProgressFill.Size = UDim2.new(1, 0, 1, 0)
    ProgressFill.BorderSizePixel = 0

    -- Animations
    local fadeInTween = TweenService:Create(ToastFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.25})
    local textFadeInTween = TweenService:Create(MessageLabel, TweenInfo.new(0.5), {TextTransparency = 0})
    local progressTween = TweenService:Create(ProgressFill, TweenInfo.new(duration - 1, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})

    fadeInTween:Play()
    textFadeInTween:Play()
    progressTween:Play()

    task.delay(duration, function()
        local fadeOutTween = TweenService:Create(ToastFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local textFadeOutTween = TweenService:Create(MessageLabel, TweenInfo.new(0.5), {TextTransparency = 1})
        fadeOutTween:Play()
        textFadeOutTween:Play()
        fadeOutTween.Completed:Wait()
        ScreenGui:Destroy()
    end)
end

return Toast
