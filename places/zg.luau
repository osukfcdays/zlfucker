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




local TeamsTable = {
    human = plrs:Chat(";human"),
    zombie = plrs:Chat(";zombie")
}

local find = {
    Melee = "Hit"
}

local SignsTable = {
    AntiZombieSign = lplr:FindFirstChild("AntiZombieSign", true) or char:FindFirstChild("AntiZombieSign", true),
    AntiZombieSign2 = lplr:FindFirstChild("AntiZombieSign2", true) or char:FindFirstChild("AntiZombieSign2", true),
    AntiZombieSign3 = lplr:FindFirstChild("AntiZombieSign3", true) or char:FindFirstChild("AntiZombieSign", true),
    ZombieSign = lplr:FindFirstChild("ZombieSign", true) or char:FindFirstChild("ZombieSign"),
    ZombieSign2 = lplr:FindFirstChild("ZombieSign2", true) or char:FindFirstChild("ZombieSign2", true)
}


for i,v in find do
    find[i] = function(FindItem)
        local FindingItem = (FindItem and (plrs:FindFirstChild(v, true) or char:FindFirstChild(v, true)))
    return ((FindingItem and FindingItem.Parent.Parent) or nil)
    end
end



local changeTeam 
do
    local TeamsTable = {
        human = plrs:Chat(";human"),
        zombie = plrs:Chat(";zombie")
    }
    changeTeam = function(Team)
        return TeamsTable[Team.Name]()
    end
end

local Teamcheck = function(v)
    if lplr.Team ~= v then
        changeTeam(v)
        
        repeat
            task.wait()
        until lplr.Team == v
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
    if lplr.Team == Zombie then
         plrs:Chat(";human")
    else
        gui:Notify("You are already a Human")
    end
end)

tabs.Teams:CreateButton("Become Zombie", function()
    if lplr.Team == Human then
         plrs:Chat(";zombie") 
    else
        gui:Notify("You are already a Zombie")
    end
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
    if SignsTable.AntiZombieSign and SignsTable.AntiZombieSign2 and SignsTable.AntiZombieSign3 and SignsTable.ZombieSign and SignsTable.ZombieSign2 then
        gui:Notify("You already have every sign")
    else
        fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector, 0)
        fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector, 0)
        fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector, 0)
        fireclickdetector(workspace.Interaction.ZombieSign.ClickDetector, 0)
        fireclickdetector(workspace.Interaction:GetChildren()[15].ClickDetector or workspace.Interaction:GetChildren()[16].ClickDetector, 0)
    end
end)
