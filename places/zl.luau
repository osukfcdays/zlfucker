-- if curious, you may request this script to be documented

local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Items = true,
    -- Teams = true,
    Client = true,
    Server = true,
    Teleports = true,
    Gamepass = true,
    --Extra = true
}

do
    local tab = gui:CreateTab("Changelog")
    local btn : TextButton = tab:CreateButton("test").inst
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.TextScaled = false
    btn.TextYAlignment = Enum.TextYAlignment.Top
    btn.TextSize = 24
    btn.Text = [[
    + Added Teleports.
    + Added Zombie Face/SkinColor changing.
    + Fixed 'no desc passed issue'.
    - Cure/Virus are still broken right now because of current update.
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
local pStats = lplr:WaitForChild("stats")

function GetHumRootPart(char)
    local HumRootPart = char:FindFirstChild("HumanoidRootPart")
    return HumRootPart
end

local find = {
    Gun = "InflictTarget",
    Knife = "Animations",
    Infect = "Infect"
}

for i, v in find do
    find[i] = function(recurs)
        local res = (recurs and (plrs:FindFirstChild(v, true) or workspace:FindFirstChild(v, true))) or (lplr.Backpack:FindFirstChild(v, true) or lplr.Character:FindFirstChild(v, true))
        return ((res and res.Parent.Parent) or nil)
    end
end

do
    local blacklistedScripts = {
        "States",
        "Anti-Exploits"
    }

    if lplr.Character then
        for _, v in blacklistedScripts do
            if lplr.Character:FindFirstChild(v) then
                lplr.Character[v]:Destroy()
            end
        end
    end
    table.insert(cons, lplr.CharacterAdded:Connect(function(chr)
        for _, v in blacklistedScripts do
            chr:WaitForChild(v):Destroy()
        end
    end))
    networkCli:SetOutgoingKBPSLimit(tonumber("-inf")) -- experimental
end


tabs.Client:CreateButton("Destroy Zones", function()
    for _, v in {starGui:FindFirstChild("PlayerLocalScripts(ReOnSp)"), lplr.PlayerGui:FindFirstChild("PlayerLocalScripts(ReOnSp)")} do
        if v then
            for _, v in v:GetChildren() do
                if v.ClassName == "LocalScript" then
                    v:Destroy()
                end
            end
        end
    end

    workspace.AntiGlitch:Destroy()
    workspace.ZombieBlockers:Destroy()
    workspace["Map Wall"].BaseWalls:Destroy()
end)

do
    local godGun = {
        FireRate = 0.03,
        Auto = true,
        AmmoPerClip = math.huge,
        ReloadTime = 0,
        BaseDamage = 999,
        HeadshotDamageMultiplier = 999,
        Spread = 0,
        CameraShakingEnabled = false,
        BulletSpeed = 9e9,
        Piercing = 1
    }
    local spamGun = table.clone(godGun)
    spamGun.Auto = false
    spamGun.FireRate = 0

    local modGun = function(conf)
        local gun = find.Gun(true)
        assert(gun, "You dont have a gun")

        local mod = gun:FindFirstChild("Setting")
        assert(mod, "Your gun is broken")
        mod = require(mod)

        for i, v in conf do
            mod[i] = v
        end

        if gun.Parent == lplr.Character then
            lplr.Character.Humanoid:UnequipTools()
            lplr.Character.Humanoid:EquipTool(gun)
        end
    end
    tabs.Items:CreateButton("God Gun", modGun, godGun)
    tabs.Items:CreateButton("Spam Gun", modGun, spamGun)
end

tabs.Client:CreateToggle("Ragdoll", function()
    rStor.Remotes.ChangeState:FireServer("Ragdoll")
end)

--[[local itemFuncs = { 
    Virus = emptyFunc,
    Cure = emptyFunc
}
do
    local itemRemotes = {
        Virus = game:GetService("ReplicatedStorage").Remotes.GiveVirus,
        Cure = game:GetService("ReplicatedStorage").Remotes.GiveCure
    }

    local transTbl = {
        Virus = Teams.Zombie,
        Cure = Teams.Human
    }

    for i, v in itemRemotes do
        tabs.Items:CreateButton("Give " .. i, v.FireServer, v)

        itemFuncs[i] = function()
            v.FireServer(v)
            local res = plrs.LocalPlayer.Backpack:WaitForChild(i, 1)
            if res then
                plrs.LocalPlayer.Backpack[i].Name ..= "_used"
                res:WaitForChild("UseSelf"):FireServer()
            else
                itemFuncs[i]()
            end
        end
        tabs.Teams:CreateButton("Become " .. transTbl[i].Name, itemFuncs[i])
    end

    local tCons = {}
    tabs.Extra:CreateToggle("Cure Autofarm", function(callback)
        if callback then
            local changed = true
            table.insert(tCons, pStats.Credits:GetPropertyChangedSignal("Value"):Connect(function()
                changed = true
            end))

            table.insert(tCons, runServ.PreRender:Connect(function()
                if changed then
                    changed = false
                    itemFuncs.Cure()
                end
            end))

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
end

local changeTeam
do
    local transTbl = {
        Zombie = itemFuncs.Virus,
        Human = itemFuncs.Cure
    }
    changeTeam = function(t)
        return transTbl[t.Name]()
    end
end]]

local checkTeam = function(v)
    gui:Notify("You must manually turn into a " .. string.format(v.Name), lplr.Team == v)
    --[[if lplr.Team ~= v then
        changeTeam(v)

        repeat
            task.wait()
        until lplr.Team == v
    end]]
end

local remote
local findRemote = function()
    if not remote or remote.Parent == nil then
        remote = find.Gun(true)
        assert(remote, "no gun in server")
        remote = remote:FindFirstChild("InflictTarget", true)
    end
end

local shootPlr = function(v, dmg)
    remote:FireServer(
        v.Character.Humanoid,
        v.Character.Humanoid.RootPart,
        (dmg or v.Character.Humanoid.MaxHealth),
        CFrame.new((lplr.Character.Humanoid.RootPart.CFrame * CFrame.new(0, 1.5, 0)).Position, v.Character.Humanoid.RootPart.Position).LookVector,
        2,
        0,
        false
    )
end

do
    local loopTbl = {}
    local hookChr = function(p, c)
        if p.Team ~= lplr.Team then
            c:WaitForChild("Humanoid")
            c:WaitForChild("HumanoidRootPart")

            repeat
                task.wait()
            until not c:FindFirstChild("ForceField")

            table.insert(loopTbl, p)
        end
    end
    local tCons = {}
    local hookPlr = function(p)
        if p.Character then
            coroutine.wrap(hookChr)(p, p.Character)
        end
        table.insert(tCons, p.CharacterAdded:Connect(function(c)
            hookChr(p, c)
        end))
    end

    local transTbl = {
        Zombie = "Human",
        Human = "Zombie"
    }
    for _, team in Teams:GetTeams() do
        local tName = transTbl[team.Name]
        tabs.Server:CreateButton("Kill " .. tName, function()
            checkTeam(team)
            findRemote()

            for _, v in plrs:GetPlayers() do
                if lplr ~= v and v.Character and v.Team ~= lplr.Team and v.Character.PrimaryPart then
                    shootPlr(v)
                end
            end
        end)

        tabs.Server:CreateButton("God " .. tName, function()
            checkTeam(team)
            findRemote()
            
            for _, v in game.Players:GetPlayers() do
                if v.Team ~= lplr.Team and v.Character and v.Character.PrimaryPart then
                    shootPlr(v, tonumber("nan"))
                end
            end
        end)

        local deb
        tabs.Server:CreateToggle("Loop Kill " .. transTbl[team.Name], function(v)
            deb = v
            if deb then
                checkTeam(team)

                table.insert(tCons, plrs.PlayerAdded:Connect(hookPlr))
                for _, v in plrs:GetPlayers() do
                    hookPlr(v)
                end
                
                repeat
                    findRemote()
                    for i, v in loopTbl do
                        if v.Character and v.Team ~= lplr.Team and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and not v.Character:FindFirstChildWhichIsA("ForceField") then
                            shootPlr(v)
                        else
                            table.remove(loopTbl, i)
                        end
                    end
                    task.wait()
                until not deb
            else
                for _, v in tCons do
                    v:Disconnect()
                end
                table.clear(tCons)
                table.clear(loopTbl)
            end
        end)
    end
end

tabs.Server:CreateButton("Infect Humans", function()
    checkTeam(Teams.Zombie)
    lplr.Character.Infect.Activated:Connect(function()
        for _, v in plrs:GetPlayers() do
            if lplr ~= v and v.Character and v.Team ~= lplr.Team and v.Character.PrimaryPart then
                firetouchinterest(lplr.Character.RightHand, v.Character.PrimaryPart, 0)
                firetouchinterest(lplr.Character.RightHand, v.Character.PrimaryPart, 1)
            end
        end
    end)
    gui:Notify("Equip and spam the infect tool to infect")
end)

do
    local remotes = {}
    local tCons = {}
    local warning
    local tog
    tog = tabs.Server:CreateToggle("Lag Server", function(callback)
        if not warning then
            warning = true
            tog.Enabled = false
            gui:Notify("Your ping will NOT recover, rejoin after disabling")
            return
        end

        if callback then
            for _, v in plrs:GetPlayers() do
                table.insert(remotes, v.Backpack:FindFirstChild("reload", true))
                if v.Character then
                    table.insert(remotes, v.Character:FindFirstChild("reload", true))
                end
            end

            local packetSize = #remotes * 700
            for i = 1, #remotes do
                local v = remotes[i]
                table.insert(tCons, runServ.PreRender:Connect(function()
                    coroutine.wrap(function()
                        for _ = 1, packetSize do
                            coroutine.wrap(v.FireServer)(v)
                        end
                    end)()
                end))
            end
        else
            coroutine.wrap(TeleportService.TeleportToPlaceInstance)(TeleportService, game.PlaceId, game.JobId)
            for _, v in tCons do
                v:Disconnect()
            end
            table.clear(tCons)
            table.clear(remotes)
        end
    end)
end
-- level 100 boss's code above


-- dogshit niggas code below
tabs.Gamepass:CreateButton("Zombie face Gamepass", function()
    lplr.PlayerGui.Main.ChooseFaceFrame.Visible = true
end)

tabs.Gamepass:CreateButton("Zombie skin color Gamepass", function()
    lplr.PlayerGui.Main.ChooseColorFrame.Visible = true
end)

tabs.Gamepass:CreateButton("Cure/Virus machines Gamepass", function()
    for _, v in rStor.LocalFolder:GetChildren() do
        if v.ClassName == "Model" then
            v.Parent = workspace
        end
    end
    gui:Notify("Gamepass Machines are currently broken.")
end)

tabs.Teleports:CreateButton("Human Spawn", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(108.507301, 2.99802589, 21.1811543, -0.999974489, 6.69067859e-08, -0.00714055588, 6.73346392e-08, 1, -5.96783067e-08, 0.00714055588, -6.01575962e-08, -0.999974489)
end)

tabs.Teleports:CreateButton("Zombie Spawn", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(-77.0017929, 2.99802589, 88.050827, 0.999998748, -2.56961403e-08, 0.00158172031, 2.56525929e-08, 1, 2.75529164e-08, -0.00158172031, -2.75123071e-08, 0.999998748)
end)

tabs.Teleports:CreateButton("Virus Room", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(-62.0080452, -15.501976, -51.7825928, 0.999956429, 2.60252282e-08, 0.00933171995, -2.59568829e-08, 1, -7.44509965e-09, -0.00933171995, 7.20255322e-09, 0.999956429)
end)

tabs.Teleports:CreateButton("Upstairs Cure room", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(-37.5837288, 2.99802613, -6.82807255, 0.999866545, 2.99475147e-08, 0.0163355526, -3.00902876e-08, 1, 8.49411652e-09, -0.0163355526, -8.98452512e-09, 0.999866545)
end)

tabs.Teleports:CreateButton("Downstairs Cure room", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(-89.571701, -15.5019779, 68.9455948, 0.999979734, -5.49140289e-09, -0.00636379281, 5.43602141e-09, 1, -8.71987904e-09, 0.00636379281, 8.68510863e-09, 0.999979734)
end)

tabs.Teleports:CreateButton("Secruity Room", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(170.688843, 2.99802589, -7.46687269, -0.00315899728, -1.09685722e-07, -0.999994993, -1.74622983e-10, 1, -1.09685722e-07, 0.999994993, -1.74622983e-10, -0.00315899728)
end)

tabs.Teleports:CreateButton("Roof", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(10.5755024, 25.498024, 32.7063293, -0.999892056, 1.2178937e-08, 0.0146923074, 1.24196662e-08, 1, 1.62934413e-08, -0.0146923074, 1.64741554e-08, -0.999892056)
end)

tabs.Teleports:CreateButton("Outside of Map", function()
    GetHumRootPart(lplr.Character).CFrame = CFrame.new(40.5333252, 2.59802508, 1005.94537, -0.999990642, -3.43452164e-08, -0.00432587136, -3.4408604e-08, 1, 1.45791699e-08, 0.00432587136, 1.47278811e-08, -0.999990642)
end)
