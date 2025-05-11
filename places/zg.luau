local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Teams = true,
    Items = true,
    Client = true,
    Server = true,
    Extra = true
}

--[[do -- for later, dont need rn
    local tab = gui:CreateTab("Changelog")
    local btn : TextButton = tab:CreateButton("test").inst
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextScaled = false
    btn.TextYAlignment = Enum.TextYAlignment.Top
    btn.TextSize = 24
    btn.Text = 
end]]

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


local find = {
    Melee = "Hit"
}



for i,v in find do
    find[i] = function(FindItem)
        local FindingItem = (FindItem and (plrs:FindFirstChild(v, true) or char:FindFirstChild(v, true)))
    return ((FindingItem and FindingItem.Parent.Parent) or nil)
    end
end



tabs.Client:CreateButton("Remove Barriers", function()
    workspace.Interaction.ZombieDoor:Destroy()
    workspace.Interaction.ZombieDoor2:Destroy()
    workspace.Interaction.ZombieDoor3:Destroy()
    workspace.Scripted.NoZombie.DisplayedBarrier:Destroy()
    workspace.Scripted.NoZombie.ActualBarrier:Destroy()
end)

tabs.Teams:CreateButton("Become Human", function()
    char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)

tabs.Teams:CreateButton("Become Zombie", function()
    plrs:Chat(";zombie") 
end)

tabs.Items:CreateButton("Give Antidote", function()
    if not lplr:FindFirstChild("Antidote", true) and not char:FindFirstChild("Antidote", true) then 
        fireclickdetector(workspace.Interaction.ToolGivers.Antidote.ClickDetector, 0)
    else
        gui:Notify("You already have a Antidote")
    end
end)

tabs.Items:CreateButton("Unlock Fire Axe", function()
    if workspace.Interaction.UnlockedWeapons["Fire Axe"].head.Color ~= Color3.fromRGB(163,54,54) then
        fireclickdetector(workspace.Interaction.Weapons["Fire Axe"].ClickDetector, 0) 
        gui:Notify("The Fire Axe can be found in the Armory If you need to reEquip it.")
    else
        gui:Notify("You already have the Fire Axe, It can be found in the Armory.")
    end
end)

tabs.Items:CreateButton("Give Rainbow Potion", function()
    if not lplr:FindFirstChild("Rainbow Potion", true) and not char:FindFirstChild("Rainbow Potion", true) then
        fireclickdetector(workspace.Interaction.ToolGivers["Rainbow Potion"].ClickDetector, 0)
    else
        gui:Notify("You already have a Rainbow Potion")
    end
end)

tabs.Items:CreateButton("Give all Signs", function()
if not lplr:FindFirstChild("AntiZombieSign", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("AntiZombieSign2", true) and not char:FindFirstChild("AntiZombieSign2", true) and not lplr:FindFirstChild("AntiZombieSign3", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("ZombieSign", true) and not char:FindFirstChild("ZombieSign") and not lplr:FindFirstChild("ZombieSign2", true) and not char:FindFirstChild("ZombieSign2", true) then
    fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector, 0)
    fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector, 0)
    fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector, 0)
    fireclickdetector(workspace.Interaction.ZombieSign.ClickDetector, 0)
    fireclickdetector(workspace.Interaction:GetChildren()[15].ClickDetector or workspace.Interaction:GetChildren()[16].ClickDetector, 0)
else
    gui:Notify("You already have every sign")
end
end)
