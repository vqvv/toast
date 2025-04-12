local Toast = {}
Toast.__index = Toast

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local MAX_TOASTS = 5
local TOAST_DURATION = 3

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToastGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

local container = Instance.new("Frame")
container.Name = "ToastContainer"
container.AnchorPoint = Vector2.new(1, 0)
container.Position = UDim2.new(1, -20, 0, 20)
container.Size = UDim2.new(0, 300, 1, -40)
container.BackgroundTransparency = 1
container.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

function Toast:Notify(text, options)
	local duration = options and options.Duration or TOAST_DURATION
	local bgColor = options and options.Color or Color3.fromRGB(30, 30, 30)

	local toast = Instance.new("Frame")
	toast.BackgroundColor3 = bgColor
	toast.Size = UDim2.new(1, 0, 0, 0)
	toast.AutomaticSize = Enum.AutomaticSize.Y
	toast.BorderSizePixel = 0
	toast.BackgroundTransparency = 0.1
	toast.ClipsDescendants = true
	toast.Parent = container
	toast.LayoutOrder = -tick()

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toast

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = toast

	local label = Instance.new("TextLabel")
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextWrapped = true
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = toast

	local appearTween = TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.05
	})
	appearTween:Play()

	task.delay(duration, function()
		local disappearTween = TweenService:Create(toast, TweenInfo.new(0.3), {
			BackgroundTransparency = 1
		})
		disappearTween:Play()
		disappearTween.Completed:Wait()
		toast:Destroy()
	end)

	while #container:GetChildren() > MAX_TOASTS + 1 do
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
				break
			end
		end
	end
end

return Toast
