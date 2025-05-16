local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Teams = true,
    Items = true,
    Weapons = true,
    Client = true,
    Server = true,
}

do 
    local tab = gui:CreateTab("Changelog")
    local btn : TextButton = tab:CreateButton("test").inst
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextScaled = false
    btn.TextYAlignment = Enum.TextYAlignment.Top
    btn.TextSize = 24
    btn.Text = [[
    + Added Spawn Zombies.
    + Added Unlock Classic Sword.
    + Added Get Iron Sword.
    + Adjusted Lag Server values so Roblox doesnt freeze or crash.
    + Fixed Give all Signs.
    + Fixed Become Human.
    + Fixed "Sit nearby Npc Zombies" only sitting one type, This is based off network ownership so only Zombies attacking YOU will sit.
    ]]
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


function GetHumRootPart(char)
	local HumRootPart = char:FindFirstChild("HumanoidRootPart")
	return HumRootPart
end



local find = {
    Melee = "Hit"
}



for i,v in find do
    find[i] = function(FindItem)
        local FindingItem = (FindItem and (plrs:FindFirstChild(v, true) or char:FindFirstChild(v, true)))
    return ((FindingItem and FindingItem.Parent.Parent) or nil)
    end
end



tabs.Teams:CreateButton("Become Human", function()
    if lplr.Team == Teams.Human then
        gui:Notify("You're already human")
    else
        lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
    end
end)

tabs.Teams:CreateButton("Become Zombie", function()
    if lplr.Team == Teams.Zombie then
        gui:Notify("You're already a zombie")
    else
        plrs:Chat(";zombie") 
    end
end)



tabs.Items:CreateButton("Give Antidote", function()
    if not lplr:FindFirstChild("Antidote", true) and not char:FindFirstChild("Antidote", true) then 
        fireclickdetector(workspace.Interaction.ToolGivers.Antidote.ClickDetector, 0)
    else
        gui:Notify("You already have a Antidote")
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
    if lplr.Team == Teams.Human then
        if not lplr:FindFirstChild("AntiZombieSign", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("AntiZombieSign2", true) and not char:FindFirstChild("AntiZombieSign2", true) and not lplr:FindFirstChild("AntiZombieSign3", true) and not char:FindFirstChild("AntiZombieSign3", true) then
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction:GetChildren()[15].ClickDetector or workspace.Interaction:GetChildren()[16].ClickDetector, 0)
        else
            gui:Notify("You already have every sign.")
        end
    else
        if not lplr:FindFirstChild("AntiZombieSign", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("AntiZombieSign2", true) and not char:FindFirstChild("AntiZombieSign2", true) and not lplr:FindFirstChild("AntiZombieSign3", true) and not char:FindFirstChild("AntiZombieSign", true) and not lplr:FindFirstChild("ZombieSign", true) and not char:FindFirstChild("ZombieSign") and not lplr:FindFirstChild("ZombieSign2", true) and not char:FindFirstChild("ZombieSign2", true) then
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign2.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ToolGivers.AntiZombieSign3.ClickDetector, 0)
            fireclickdetector(workspace.Interaction.ZombieSign.ClickDetector, 0)
            fireclickdetector(workspace.Interaction:GetChildren()[15].ClickDetector or workspace.Interaction:GetChildren()[16].ClickDetector, 0)
        else
            gui:Notify("You already have every sign.")
        end
    end
end)



tabs.Weapons:CreateButton("Unlock Fire Axe", function()
    if workspace.Interaction.UnlockedWeapons["Fire Axe"].head.Color ~= Color3.fromRGB(163,54,54) then
        fireclickdetector(workspace.Interaction.Weapons["Fire Axe"].ClickDetector, 0) 
    else
        gui:Notify("You already have the Fire Axe, It can be found in the Armory.")
    end
end)

tabs.Weapons:CreateButton("Unlock Classic Sword", function() -- yes this method was kinda half assed for CFrame shit.
    local checkPath = workspace.Interaction.UnlockedWeapons["Classic Sword"].ProximityPrompt
    
    if workspace.Interaction.Grave:FindFirstChild("Part") then
        workspace.Interaction.Grave.Part:Destroy()
    end
    task.wait(0.1)
    if checkPath.ActionText ~= "Classic Sword" then
        workspace.Interaction.SwordTouch.ProximityPrompt.HoldDuration = 0.001
        GetHumRootPart(lplr.Character).CFrame = CFrame.new(-168.574799, 44.0623779, 88.8942108, -0.00475128274, -6.16009355e-10, 0.999988735, 1.60659113e-08, 1, 6.92350899e-10, -0.999988735, 1.60690181e-08, -0.00475128274)
        task.wait(0.1)
        fireproximityprompt(workspace.Interaction.SwordTouch.ProximityPrompt) 
        task.wait(0.1)
        GetHumRootPart(lplr.Character).CFrame = CFrame.new(-81.5, 22.5, 66, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    else 
        gui:Notify("You already have the sword, It can be found in the Armory.")
    end
end)

tabs.Weapons:CreateButton("Get Iron Sword", function()
    local CheckPath = workspace.Interaction.Ironsword.SwordCollectPieces

    if CheckPath:FindFirstChild("StickCollect") and CheckPath:FindFirstChild("IronOre1") and CheckPath:FindFirstChild("IronOre2") then
        fireclickdetector(workspace.Interaction.Ironsword.SwordCollectPieces:WaitForChild("StickCollect"):WaitForChild("ClickDetector"), 0)
        fireclickdetector(workspace.Interaction.Ironsword.SwordCollectPieces:WaitForChild("IronOre1"):WaitForChild("ClickDetector"), 0)
        fireclickdetector(workspace.Interaction.Ironsword.SwordCollectPieces:WaitForChild("IronOre2"):WaitForChild("ClickDetector"), 0)
        
        task.wait(0.1)
        
        fireclickdetector(workspace.Interaction.Ironsword.IronSword:WaitForChild("ClickDetector"), 0)
    else
        fireclickdetector(workspace.Interaction.Ironsword.IronSword:WaitForChild("ClickDetector"), 0)
    end
end)



tabs.Client:CreateButton("Remove Barriers", function()
    workspace.Interaction.ZombieDoor:Destroy()
    workspace.Interaction.ZombieDoor2:Destroy()
    workspace.Interaction.ZombieDoor3:Destroy()
    workspace.Scripted.NoZombie.DisplayedBarrier:Destroy()
    workspace.Scripted.NoZombie.ActualBarrier:Destroy()
end)



tabs.Server:CreateButton("Lag Server", function()
    for LagServer = 1, 500000 do
        game:GetService("ReplicatedStorage").NetworkEvents.RemoteEvent:FireServer("PLACE_LANDMINE")
    end
end)

tabs.Server:CreateButton("Spawn Zombies", function()
    game:GetService("ReplicatedStorage").Remotes.ZombieRelated.Necro.AbilityPlayer:FireServer()
end)

local tCons = {}
tabs.Server:CreateToggle("Sit nearby Npc Zombies", function(StopSittingZombies)
    if StopSittingZombies then

        for _,v in workspace.LivingThings:GetChildren() do
            if v.Humanoid.DisplayName == "Npc" or v.Humanoid.DisplayName == "Summoned Zombie" then
                v.Humanoid.Sit = true
            end
        end
        for _, v in tCons do
            table.insert(cons, v)
        end
    elseif #tCons > 0 then
        for _, v in tCons do
            v:Disconnect()
        end
        table.clear(tCons)
    end
end)
