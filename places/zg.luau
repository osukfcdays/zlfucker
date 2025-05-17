-- created by reret (osufckdays), qa tested by main dev

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
    + Killaura
    + Summon Zombies
    + Unlock Classic Sword
    + Unlock Fireaxe
    + Get IronSword
    + Become Zombie
    + Become Human
    + Lag Server
    + Spawn Landmines
    + Remove Barriers
    + Give all Signs
    + Give Antidote
    + Give Rainbow Potion
    + Sit nearby Zombies]]
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
        fireclickdetector(workspace.Interaction.Weapons["Fire Axe"].ClickDetector) 
    else
        gui:Notify("You already have the Fire Axe, It can be found in the Armory.")
    end
end)

tabs.Weapons:CreateButton("Unlock Classic Sword", function() -- yes this method was kinda half assed for CFrame shit.
    local checkPath = workspace.Interaction.UnlockedWeapons["Classic Sword"].ProximityPrompt
    
    if workspace.Interaction.Grave:FindFirstChild("Part") then
        workspace.Interaction.Grave.Part:Destroy()
    end

    if checkPath.ActionText ~= "Classic Sword" then
        GetHumRootPart(lplr.Character).CFrame = CFrame.new(-168.574799, 44.0623779, 88.8942108, -0.00475128274, -6.16009355e-10, 0.999988735, 1.60659113e-08, 1, 6.92350899e-10, -0.999988735, 1.60690181e-08, -0.00475128274)
        repeat
            fireproximityprompt(workspace.Interaction.SwordTouch.ProximityPrompt)
            task.wait()
        until checkPath.ActionText == "Classic Sword"
        GetHumRootPart(lplr.Character).CFrame = CFrame.new(-81.5, 22.5, 66, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    else 
        gui:Notify("You already have the sword, It can be found in the Armory.")
    end
end)

tabs.Weapons:CreateButton("Get Iron Sword", function()
    local CheckPath = workspace.Interaction.Ironsword.SwordCollectPieces

    if CheckPath:FindFirstChild("StickCollect") and CheckPath:FindFirstChild("IronOre1") and CheckPath:FindFirstChild("IronOre2") then
        fireclickdetector(workspace.Interaction.Ironsword.SwordCollectPieces:WaitForChild("StickCollect"):WaitForChild("ClickDetector"))
        fireclickdetector(workspace.Interaction.Ironsword.SwordCollectPieces:WaitForChild("IronOre1"):WaitForChild("ClickDetector"))
        fireclickdetector(workspace.Interaction.Ironsword.SwordCollectPieces:WaitForChild("IronOre2"):WaitForChild("ClickDetector"))
        fireclickdetector(workspace.Interaction.Ironsword.IronSword:WaitForChild("ClickDetector"))
    else
        fireclickdetector(workspace.Interaction.Ironsword.IronSword:WaitForChild("ClickDetector"))
    end
end)



tabs.Client:CreateButton("Remove Barriers", function()
    workspace.Interaction.ZombieDoor:Destroy()
    workspace.Interaction.ZombieDoor2:Destroy()
    workspace.Interaction.ZombieDoor3:Destroy()
    workspace.Scripted.NoZombie.DisplayedBarrier:Destroy()
    workspace.Scripted.NoZombie.ActualBarrier:Destroy()
end)

networkCli:SetOutgoingKBPSLimit(tonumber("-inf")) -- experimental
local rastorThreads = 24
local lagServer = function(event, ...)
    for _ = 1, rastorThreads do
        coroutine.wrap(function(...)
            for _ = 1, (rastorThreads * 1000) do
                coroutine.wrap(event.FireServer)(event, ...)
            end
        end)(...)
    end
end

local rejoin = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

tabs.Server:CreateToggle("Lag Server", function(c)
    if c then
        workspace.Interaction.PlayerPlaced.Parent = nil
        lagServer(game:GetService("ReplicatedStorage").NetworkEvents.RemoteEvent, "PLACE_LANDMINE")
    else
        rejoin()
    end
end)

tabs.Server:CreateToggle("Lag Server (Necro Edition)", function(c)
    if c then
        lagServer(game:GetService("ReplicatedStorage").Remotes.ZombieRelated.Necro.AbilityPlayer)
    else
        rejoin()
    end
end)

tabs.Server:CreateButton("Summon Zombies", function()
    game:GetService("ReplicatedStorage").Remotes.ZombieRelated.Necro.AbilityPlayer:FireServer()
end)

tabs.Server:CreateButton("Summon Landmines", function()
    game:GetService("ReplicatedStorage").NetworkEvents.RemoteEvent:FireServer("PLACE_LANDMINE")
end)

local living = workspace.LivingThings
tabs.Server:CreateToggle("Unload Entites", function(c)
    lplr.Character.Parent = (c and workspace) or living
    if c then
        living.Parent = nil
    else
        living.Parent = workspace
    end
end)

local Start 
local tCons = {}
tabs.Server:CreateToggle("Sit nearby Npc Zombies", function(v)
    Start = v

    if Start then
        repeat 
            for _, v in living:GetChildren() do
                if v.Humanoid.DisplayName == "Npc" or v.Humanoid.DisplayName == "Summoned Zombie" then
                    v.Humanoid.Sit = true
                end
                task.wait()
            end
        until not Start
    elseif #tCons > 0 then
        for _, v in tCons do
            Start:Disconnect()
        end
        table.clear(tCons)
    end
end)

do
    local tgl
    local event = rStor.Remotes.Melee.Damage
    local eventC = 0
    tgl = tabs.Server:CreateToggle("Killaura", function(c)
        if c then
            repeat
                if lplr.Team == Teams.Zombie then
                    event = rStor.Remotes.ZombieRelated.PlayerAttack
                else
                    event = rStor.Remotes.Melee.Damage
                end
                if lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool") then
                    for _, v in living:GetChildren() do
                        if v:GetAttribute("Team") and v:GetAttribute("Team") ~= lplr.Character:GetAttribute("Team") then
                            local hum = v:FindFirstChildWhichIsA("Humanoid")
                            if hum and hum.Health > 0 and hum.RootPart and (hum.RootPart.Position - lplr.Character.Humanoid.RootPart.Position).Magnitude <= 10 then
                                if eventC < 100 then
                                    coroutine.wrap(function()
                                        eventC += 1
                                        event:InvokeServer(hum.RootPart)
                                        eventC -= 1
                                    end)()
                                end
                            end
                        end
                    end
                end
                task.wait()
            until not tgl.Enabled
        end
    end)
end