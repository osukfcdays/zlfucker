local lib = {}

local coreGui = cloneref(game:GetService("CoreGui"))
local assets = cloneref(game):GetObjects(getcustomasset(export_file))[1]

local clearChildren = function(...)
    for _, v in {...} do
        for _, v in v:GetChildren() do
            if not string.find(v.Name, "UI") then
                v:Destroy()
            end
        end
    end
end

function lib:CreateGui(name)
    local sGui = Instance.new("ScreenGui", coreGui)
    sGui.DisplayOrder = math.huge
    sGui.OnTopOfCoreBlur = true

    local cons = {}
    local tabs = {}
    local tgls = {}
    local gFuncs = {
        cons = cons,
        tabs = tabs
    }

    local sFrame : Frame = assets.Frame:Clone()
    sFrame.Parent = sGui
    
    -- to replace this, .Active ruins mouse input, .Draggable is stupid in the big 2025
    sFrame.Draggable = true
    sFrame.Active = true

    clearChildren(sFrame.content.padding.stuf, sFrame.content.tabs)

    sFrame.top.TextLabel.Text = name

    local queueNotifs = {}
    local notifIndx = 0
    local manageNotif = function()
        sFrame.content.notif.msg.title.Text = queueNotifs[1][2] or "ZLFucker"
        sFrame.content.notif.msg.desc.Text = queueNotifs[1][1] or "no desc was passed"
        sFrame.content.notif.Visible = true
    end

    function gFuncs:Notify(desc, tit)
        table.insert(queueNotifs, {
            desc,
            tit
        })
        manageNotif()
    end

    sFrame.content.notif.Visible = false
    table.insert(cons, sFrame.content.notif.msg.btn.MouseButton1Click:Connect(function()
        sFrame.content.notif.Visible = false
        if queueNotifs[1] then
            table.remove(queueNotifs, 1)
            if queueNotifs[1] then
                manageNotif()
            end
        end
    end))

    function gFuncs:CreateTab(name)
        local tFr = assets.Frame.content.padding.stuf:Clone()
        local tBtn = assets.Frame.content.tabs.TextButton:Clone()

        tBtn.Text = name
        tBtn.Parent = sFrame.content.tabs

        table.insert(cons, tBtn.MouseButton1Click:Connect(function()
            for _, v in tabs do
                v.Visible = false
                v.Parent = nil
            end
            tFr.Parent = sFrame.content.padding
            tFr.Visible = true
        end))

        clearChildren(tFr)

        local tFuncs = {}

        function tFuncs:CreateButton(name, callback, ...)
            local args = {...}
            local btn : TextButton = assets.Frame.content.padding.stuf.TextButton:Clone()
            local bFuncs = {}

            btn.Text = name
            btn.Parent = tFr
            
            if callback then
                table.insert(cons, btn.MouseButton1Click:Connect(function()
                    coroutine.wrap(callback)(unpack(args))
                end))
            end

            return bFuncs
        end

        function tFuncs:CreateToggle(name, callback, ...)
            local args = {...}
            local btn : TextButton = assets.Frame.content.padding.stuf.TextButton:Clone()
            local bFuncs = {}

            btn.Text = "[Disabled] " .. name
            btn.Parent = tFr
            
            if callback then
                bFuncs.Function = callback
                bFuncs.Enabled = false
                table.insert(cons, btn.MouseButton1Click:Connect(function()
                    bFuncs.Enabled = not bFuncs.Enabled
                    btn.Text = (bFuncs.Enabled and "[Enabled] " .. name) or "[Disabled] " .. name
                    coroutine.wrap(callback)(bFuncs.Enabled, unpack(args))
                end))
            end

            table.insert(tgls, bFuncs)
            return bFuncs
        end

        tFr.Parent = ((#tabs <= 0) and sFrame.content.padding) or nil
        tFr.Visible = (#tabs <= 0)
        table.insert(tabs, tFr)
        return tFuncs
    end

    function gFuncs:Destruct()
        sGui:Destroy()
        for _, v in cons do
            if v then
                v:Disconnect()
            end
        end
        for _, v in tgls do
            if v.Enabled then
                coroutine.wrap(v.Function)()
            end
        end
    end

    table.insert(cons, sFrame.top.btns.close.MouseButton1Click:Connect(gFuncs.Destruct))
    
    gFuncs.inst = sGui
    gFuncs.fInst = sFrame
    return gFuncs
end

return lib