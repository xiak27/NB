-- ServerScript: 验证白名单，并监听踢出请求
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VIPEvent = Instance.new("RemoteEvent")
VIPEvent.Name = "VIPEvent"
VIPEvent.Parent = ReplicatedStorage

local KickEvent = Instance.new("RemoteEvent")
KickEvent.Name = "KickEvent"
KickEvent.Parent = ReplicatedStorage

local whitelist = {
    ["Player1"] = true,
    ["Player2"] = true,
}

Players.PlayerAdded:Connect(function(player)
    if whitelist[player.Name] then
        print(player.Name .. " is whitelisted.")
        VIPEvent:FireClient(player, true)
    else
        print(player.Name .. " is not whitelisted.")
        VIPEvent:FireClient(player, false)
    end
end)

KickEvent.OnServerEvent:Connect(function(player)
    print(player.Name .. " suspected of hooking, kicking...")
    player:Kick("⚠️ 检测到非法抓包或 Hook 行为，已踢出！")
end)
