-- 第一步：加载 WindUI 库
local WindUI = loadstring(game:HttpGet("https://your-raw-link-to-WindUI.lua"))()

-- 第二步：创建一个窗口
local Window = WindUI:CreateWindow({
    Name = "示例窗口",
    LoadingTitle = "加载中...",
    LoadingSubtitle = "请稍等",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- 第三步：创建一个选项卡
local Tab = Window:CreateTab("主选项卡")

-- 第四步：在选项卡里创建一个分区
local Section = Tab:CreateSection("我的功能分区")

-- 第五步：在分区里放一个按钮功能
Section:CreateButton({
    Name = "点击我执行功能",
    Callback = function()
        print("按钮被点击了！")
        game.Players.LocalPlayer:Kick("你好，你点击了按钮，示例功能生效！")
    end
})
