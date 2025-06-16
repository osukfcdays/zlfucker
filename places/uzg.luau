local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Teams = true,
    Items = true,
    Weapons = true,
    Client = true,
    Server = true
}

do 
    local tab = gui:CreateTab("Changelog")
    local btn : TextButton = tab:CreateButton("test").inst
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextScaled = false
    btn.TextYAlignment = Enum.TextYAlignment.Top
    btn.TextSize = 24
    btn.Text = [[]]
end

for i, v in tabs do
    tabs[i] = gui:CreateTab(i)
end

local plrs : Players = cloneref(game:GetService("Players"))
local starGui : StarterGui = cloneref(game:GetService("StarterGui"))
local starPlr : StarterPlayer = cloneref(game:GetService("StarterPlayer"))
local rStor : ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local runServ : RunService = cloneref(game:GetService("RunService"))
local networkCli : NetworkClient = cloneref(game:GetService("NetworkClient"))
local Teams : Teams = cloneref(game:GetService("Teams"))
local TeleportService : TeleportService = cloneref(game:GetService("TeleportService"))

local lplr = plrs.LocalPlayer
local char = lplr.Character
local Entities = workspace.Entities


tabs.Server:CreateButton("test", function()
  warn("fuck")
end)
