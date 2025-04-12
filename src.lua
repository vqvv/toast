-- Toast.lua 🍞
local Toast = {}

local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Player instance handling with fallbacks
local localPlayer
if RunService:IsClient() then
	localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
else
	localPlayer = nil
end

local CoreGui = game:GetService("CoreGui")

-- Toast counter for z-index management
local toastCounter = 0
local MAX_TOASTS = 5

local Themes = {
	Dark = {
		Background = Color3.fromRGB(30, 30, 30),
		Stroke = Color3.fromRGB(30, 30, 30),
		Text = Color3.fromRGB(255, 255, 255)
	},
	Light = {
		Background = Color3.fromRGB(245, 245, 245),
		Stroke = Color3.fromRGB(245, 245, 245),
		Text = Color3.fromRGB(30, 30, 30)
	}
}

function Toast:CreateToast(message, duration, themeArg)
	-- Parameter validation
	if type(message) ~= "string" then
		warn("❌ Invalid message type! Expected string, got:", type(message))
		return
	end

	duration = math.clamp(tonumber(duration) or 5, 0.5, 60)
	local theme = Themes[themeArg] or Themes.Dark

	-- Z-index management
	toastCounter = (toastCounter % MAX_TOASTS) + 1
	local baseZIndex = 100 + (toastCounter * 10)

	-- GUI container
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ToastNotification_" .. toastCounter
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = baseZIndex

	-- Parent handling with fallbacks
	local success, errorMsg = pcall(function()
		if localPlayer and localPlayer:FindFirstChild("PlayerGui") then
			ScreenGui.Parent = localPlayer.PlayerGui
		else
			ScreenGui.Parent = CoreGui
		end
	end)

	if not success then
		warn("❌ Failed to parent Toast GUI:", errorMsg)
		return
	end

	-- Size and position calculations
	local font = Enum.Font.Gotham
	local textSize = 16  -- Increased text size
	local maxWidth = 500  -- Wider toast
	local padding = 40    -- Increased padding

	local textBounds = TextService:GetTextSize(message, textSize, font, Vector2.new(maxWidth, math.huge))
	local totalHeight = math.max(44, textBounds.Y + 30)  -- Taller minimum height

	local ToastFrame = Instance.new("Frame")
	ToastFrame.Size = UDim2.new(0, maxWidth + padding * 2, 0, totalHeight)
	ToastFrame.AnchorPoint = Vector2.new(0.5, 0)
	ToastFrame.Position = UDim2.new(0.5, 0, 0, 20 + ((toastCounter - 1) * (totalHeight + 40)))  -- Increased spacing
	ToastFrame.BackgroundColor3 = theme.Background
	ToastFrame.BackgroundTransparency = 1
	ToastFrame.BorderSizePixel = 0
	ToastFrame.ZIndex = baseZIndex
	ToastFrame.Parent = ScreenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)  -- Slightly larger corner radius
	corner.Parent = ToastFrame

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = theme.Stroke
	Stroke.Thickness = 2  -- Thicker stroke
	Stroke.Transparency = 1
	Stroke.Parent = ToastFrame

	-- Text label setup
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, -padding * 2, 1, -padding)
	TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.Text = message
	TextLabel.Font = font
	TextLabel.TextColor3 = theme.Text
	TextLabel.TextSize = textSize
	TextLabel.TextWrapped = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel.BackgroundTransparency = 1
	TextLabel.RichText = true
	TextLabel.TextTransparency = 1
	TextLabel.ZIndex = baseZIndex + 1
	TextLabel.Parent = ToastFrame

	-- Animation functions
	local function tween(obj, props, time, style)
		local tweenInfo = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad)
		local tween = TweenService:Create(obj, tweenInfo, props)
		tween:Play()
		return tween
	end

	-- Animate in
	local entranceTweens = {
		tween(ToastFrame, {BackgroundTransparency = 0}),
		tween(Stroke, {Transparency = 0}),
		tween(TextLabel, {TextTransparency = 0})
	}

	-- Cleanup sequence
	task.delay(duration, function()
		-- Animate out
		local exitTweens = {
			tween(ToastFrame, {BackgroundTransparency = 1}),
			tween(Stroke, {Transparency = 1}),
			tween(TextLabel, {TextTransparency = 1})
		}

		-- Wait for exit animations to complete
		exitTweens[1].Completed:Wait()

		-- Safe destruction
		pcall(function()
			ScreenGui:Destroy()
			toastCounter = toastCounter - 1
			print("✅ Toast destroyed")
		end)
	end)
end

return Toast
