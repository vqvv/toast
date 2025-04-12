local Toast = {}

local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Border = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(235, 235, 235),
        Icon = Color3.fromRGB(100, 180, 255),
        Progress = Color3.fromRGB(100, 180, 255),
        ProgressBg = Color3.fromRGB(60, 60, 60)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Border = Color3.fromRGB(0, 0, 0),
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

    if type(positionArg) == "string" then
        position = positionArg:lower()
        duration = durationArg or duration
    elseif type(positionArg) == "number" then
        duration = positionArg
    end

    if type(themeArg) == "string" and Themes[themeArg] then
        theme = Themes[themeArg]
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ToastNotification"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    local ToastFrame = Instance.new("Frame")
    ToastFrame.Size = UDim2.new(0, 320, 0, 70)
    ToastFrame.AnchorPoint = Vector2.new(0.5, 0)
    ToastFrame.Position = position == "bottom" and UDim2.new(0.5, 0, 1, -80) or UDim2.new(0.5, 0, 0, 10)
    ToastFrame.BackgroundColor3 = theme.Background
    ToastFrame.BackgroundTransparency = 1
    ToastFrame.BorderSizePixel = 0
    ToastFrame.Parent = ScreenGui

    Instance.new("UICorner", ToastFrame).CornerRadius = UDim.new(0, 12)

    local Border = Instance.new("UIStroke", ToastFrame)
    Border.Color = theme.Border
    Border.Transparency = 1
    Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 12, 0.5, -12)
    Icon.Image = "rbxassetid://7072716662"
    Icon.BackgroundTransparency = 1
    Icon.ImageColor3 = theme.Icon
    Icon.Parent = ToastFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -48, 1, -20)
    TextLabel.Position = UDim2.new(0, 44, 0, 10)
    TextLabel.Text = message
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextColor3 = theme.Text
    TextLabel.TextSize = 17
    TextLabel.TextWrapped = true
    TextLabel.TextTransparency = 1
    TextLabel.BackgroundTransparency = 1
    TextLabel.Parent = ToastFrame

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, -24, 0, 3)
    ProgressBar.Position = UDim2.new(0, 12, 1, -8)
    ProgressBar.BackgroundColor3 = theme.ProgressBg
    ProgressBar.BorderSizePixel = 0
    ProgressBar.AnchorPoint = Vector2.new(0, 1)
    ProgressBar.Parent = ToastFrame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(1, 0, 1, 0)
    Fill.BackgroundColor3 = theme.Progress
    Fill.BorderSizePixel = 0
    Fill.Parent = ProgressBar

    -- Tweens
    local enterTween = TweenService:Create(ToastFrame, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {
        BackgroundTransparency = 0.1
    })

    local strokeIn = TweenService:Create(Border, TweenInfo.new(0.6), {Transparency = 0})
    local textFade = TweenService:Create(TextLabel, TweenInfo.new(0.6), {TextTransparency = 0})
    local progressTween = TweenService:Create(Fill, TweenInfo.new(duration - 1, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })

    enterTween:Play()
    strokeIn:Play()
    textFade:Play()
    progressTween:Play()

    task.delay(duration, function()
        local leaveTween = TweenService:Create(ToastFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic), {
            BackgroundTransparency = 1
        })
        local strokeOut = TweenService:Create(Border, TweenInfo.new(0.5), {Transparency = 1})
        local textOut = TweenService:Create(TextLabel, TweenInfo.new(0.5), {TextTransparency = 1})

        leaveTween:Play()
        strokeOut:Play()
        textOut:Play()

        leaveTween.Completed:Wait()
        ScreenGui:Destroy()
    end)
end

return Toast
