local Toast = {}

-- Function to create a toast notification
function Toast:CreateToast(message, duration)
    local ScreenGui = Instance.new("ScreenGui")
    local ToastFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local MessageLabel = Instance.new("TextLabel")

    -- ScreenGui properties
    ScreenGui.Name = "ToastNotification"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- ToastFrame properties
    ToastFrame.Name = "ToastFrame"
    ToastFrame.Parent = ScreenGui
    ToastFrame.AnchorPoint = Vector2.new(0.5, 0)
    ToastFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToastFrame.BackgroundTransparency = 0.2
    ToastFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
    ToastFrame.Size = UDim2.new(0, 300, 0, 50)

    -- Glassmorphism effect
    ToastFrame.BorderSizePixel = 0
    ToastFrame.ClipsDescendants = true

    -- UICorner for rounded edges
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = ToastFrame

    -- UIStroke for border
    UIStroke.Parent = ToastFrame
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.7

    -- MessageLabel properties
    MessageLabel.Name = "MessageLabel"
    MessageLabel.Parent = ToastFrame
    MessageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Size = UDim2.new(1, -20, 1, 0)
    MessageLabel.Position = UDim2.new(0, 10, 0, 0)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageLabel.TextScaled = true
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Tween for fade-in effect
    ToastFrame.BackgroundTransparency = 1
    MessageLabel.TextTransparency = 1
    local tweenService = game:GetService("TweenService")
    local fadeInTween = tweenService:Create(ToastFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2})
    local textFadeInTween = tweenService:Create(MessageLabel, TweenInfo.new(0.5), {TextTransparency = 0})
    fadeInTween:Play()
    textFadeInTween:Play()

    -- Auto-remove after duration
    task.delay(duration or 3, function()
        local fadeOutTween = tweenService:Create(ToastFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local textFadeOutTween = tweenService:Create(MessageLabel, TweenInfo.new(0.5), {TextTransparency = 1})
        fadeOutTween:Play()
        textFadeOutTween:Play()
        fadeOutTween.Completed:Wait()
        ScreenGui:Destroy()
    end)
end

return Toast
