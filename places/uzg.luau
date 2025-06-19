local emptyFunc = function() end
local cons = gui.cons
local tabs = {
    Teams = true,
    Items = true,
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
    btn.Text = [[
    Kill aura
    Remove Team barriers
    Become Human
    Become Zombie
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
local Entities = workspace.Entities



local find = {
    Melee = "katana" or "machete" or "wooden_bat" or"charged_bat" or "flame_katana" or "crowbar" or "hatchet" or "Attack"
}

local Barriers = {
    --"Emitters",
    "VisualBarrier",
    "Collision",
    "Protection",
    "Collission and proteciton"
}


for i,v in find do
    find[i] = function(FindItem)
        local FindingItem = (FindItem and (plrs:FindFirstChild(v, true) or char:FindFirstChild(v, true)))
    return ((FindingItem) or nil)
    end
end


tabs.Teams:CreateButton("Become Human", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateServerData"):InvokeServer("spawn_select", "human_main")
    lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)

tabs.Teams:CreateButton("Become Zombie", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateServerData"):InvokeServer("spawn_select", "zombie_main")
    lplr.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)


tabs.Client:CreateButton("Remove Team Barriers", function()
    for _,v in Barriers do
        if workspace:FindFirstChild(v, true) then
            repeat
                workspace:FindFirstChild(v, true):Destroy()
                task.wait(0.1)
            until not workspace:FindFirstChild(v, true)
        end
    end
end)

do
    local tgl
    local event = rStor.Tools.Remotes.MeleeDamage
    local eventC = 0
    local CheckRemote = rStor.Tools.Remotes.AttackStart
    tgl = tabs.Server:CreateToggle("Kill aura", function(c)
        if c then
            repeat
                if find.Melee(true) then
                    for _, v in Entities:GetChildren() do
                        if v:GetAttribute("Team") and v:GetAttribute("Team") ~= lplr.Character:GetAttribute("Team") then
                            local hum = v:FindFirstChildWhichIsA("Humanoid")
                            if hum and hum.Health > 0 and hum.RootPart and (hum.RootPart.Position - lplr.Character.Humanoid.RootPart.Position).Magnitude <= 20 then
                                if eventC < 100 then
                                    coroutine.wrap(function()
                                        eventC += 1
                                        event:FireServer(hum.RootPart)
                                        CheckRemote:FireServer(workspace:GetServerTimeNow(), workspace.DistributedGameTime)
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
