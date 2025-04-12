local Toast = {}

-- Services
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

function Toast:CreateToast(message, duration)
    duration = duration or 5  -- Default duration extended to 5 seconds

    -- Calculate text dimensions
    local textSize = TextService:GetTextSize(
        message,
        16,  -- Font size
        Enum.Font.Gotham,
        Vector2.new(300 - 80, math.huge)  -- Account for icon and padding
    )

    -- Create GUI components
    local ScreenGui = Instance.new("ScreenGui")
    local ToastFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Container = Instance.new("Frame")
    local Icon = Instance.new("ImageLabel")
    local MessageLabel = Instance.new("TextLabel")
    local ProgressBar = Instance.new("Frame")
    local ProgressFill = Instance.new("Frame")
    local UIStroke = Instance.new("UIStroke")

    -- ScreenGui setup
    ScreenGui.Name = "ToastNotification"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Toast Frame
    ToastFrame.Name = "ToastFrame"
    ToastFrame.Parent = ScreenGui
    ToastFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ToastFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToastFrame.BackgroundTransparency = 0.25
    ToastFrame.Size = UDim2.new(0, 300, 0, math.max(60, textSize.Y + 50))
    ToastFrame.Position = UDim2.new(0.5, 0, 1.2, 0)  -- Start off-screen bottom

    -- Glassmorphism effect
    UIStroke.Parent = ToastFrame
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.8

    -- Rounded corners
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = ToastFrame

    -- Inner container
    Container.Name = "Container"
    Container.Parent = ToastFrame
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, -20, 1, -20)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)

    -- Icon
    Icon.Name = "Icon"
    Icon.Parent = Container
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 0, 0, 0)
    Icon.Image = "rbxassetid://7072716662"  -- Default info icon
    Icon.ImageColor3 = Color3.fromRGB(85, 170, 255)
    Icon.BackgroundTransparency = 1

    -- Message Label
    MessageLabel.Name = "MessageLabel"
    MessageLabel.Parent = Container
    MessageLabel.Size = UDim2.new(1, -34, 1, -8)
    MessageLabel.Position = UDim2.new(0, 34, 0, 0)
    MessageLabel.Font = Enum.Font.GothamSemibold
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    MessageLabel.TextSize = 16
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.ZIndex = 2

    -- Progress Bar
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = ToastFrame
    ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ProgressBar.Size = UDim2.new(1, -20, 0, 3)
    ProgressBar.Position = UDim2.new(0, 10, 1, -8)
    ProgressBar.AnchorPoint = Vector2.new(0, 1)
    ProgressBar.BorderSizePixel = 0

    ProgressFill.Name = "ProgressFill"
    ProgressFill.Parent = ProgressBar
    ProgressFill.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    ProgressFill.Size = UDim2.new(1, 0, 1, 0)
    ProgressFill.BorderSizePixel = 0

    -- Animations
    local slideTween = TweenService:Create(
        ToastFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint),
        {Position = UDim2.new(0.5, 0, 0.9, 0)}
    )

    local fadeTween = TweenService:Create(
        ToastFrame,
        TweenInfo.new(0.3),
        {BackgroundTransparency = 0.25}
    )

    local progressTween = TweenService:Create(
        ProgressFill,
        TweenInfo.new(duration - 1, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 1, 0)}
    )

    -- Initial state
    ToastFrame.BackgroundTransparency = 1
    ProgressFill.Size = UDim2.new(1, 0, 1, 0)

    -- Animate entrance
    slideTween:Play()
    fadeTween:Play()
    task.wait(0.2)
    progressTween:Play()

    task.delay(duration, function()
        local exitTween = TweenService:Create(
            ToastFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint),
            {Position = UDim2.new(0.5, 0, 1.2, 0)}
        )
        exitTween:Play()
        exitTween.Completed:Wait()
        ScreenGui:Destroy()
    end)
end

return Toast
