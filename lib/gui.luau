local lib = {
    mobileSize = Vector2.new(800, 599) -- the minimum screen size till the gui switches into mobile scaling mode
}
local coreGui = cloneref(game:GetService("CoreGui")) -- cloneref coregui to prevent coregui detection through roblox vulns
local assets = cloneref(game):GetObjects(getcustomasset(export_file))[1] -- loads up the assets through getobjects in a clonerefed state, getcustomasset imiates a rbxassetid:// with a local file
local inputServ = cloneref(game:GetService("UserInputService"))

local clearChildren = function(...) -- ease of access function to clear out non ui elements since the assets for the gui are built up in a gui
    for _, v in {...} do -- loops through your multiple provided paths
        for _, v in v:GetChildren() do
            if not string.find(v.Name, "UI") then -- checks if its a UI type element
                v:Destroy() -- deletes the object since its not needed and to save perf
            end
        end
    end
end

function lib:CreateGui(name)
    local sGui = Instance.new("ScreenGui", coreGui) -- parents the gui to the clonerefed' coregui to prevent detections
    sGui.DisplayOrder = 9e9 -- sets the display order to overlay ontop of other roblox guis
    sGui.OnTopOfCoreBlur = true -- bypass the kick gui core blur incase of a age bypass or such

    -- arrays to store created objects through the gui
    local cons = {}
    local tabs = {}
    local tgls = {}
    local gFuncs = { -- table that is returned to the user
        cons = cons, -- table is passed so the user may put their own rbxsignals that will be unloaded through the destruct func
        tabs = tabs
    }

    local sFrame : Frame = assets.Frame:Clone() -- clones the frame asset through the getobjects load
    sFrame.Parent = sGui -- attachs the frame to screengui

    clearChildren(sFrame.content.padding.stuf, sFrame.content.tabs) -- clears all the premade assets in the cloned gui asset

    sFrame.top.TextLabel.Text = name

    local queueNotifs = {} -- creates a array to store multiple notifs
    local manageNotif = function() -- shows the data of the first index of the array
        sFrame.content.notif.msg.title.Text = queueNotifs[1][2] or "ZLFucker"
        sFrame.content.notif.msg.desc.Text = queueNotifs[1][1] or "no desc was passed"
        sFrame.content.notif.Visible = true
    end

    function gFuncs:Notify(desc, tit)
        table.insert(queueNotifs, { -- adds the notif to the queue
            desc,
            tit
        })
        manageNotif() -- tells the gui to scan the table once again
    end

    sFrame.content.notif.Visible = false
    table.insert(cons, sFrame.content.notif.msg.btn.MouseButton1Click:Connect(function() -- connects the OK button of the notif
        sFrame.content.notif.Visible = false -- hides the notif gui
        if queueNotifs[1] then -- checks for the current index's existance
            table.remove(queueNotifs, 1) -- removes it
            if queueNotifs[1] then -- checks if theres is another pending notif
                manageNotif() -- tells the gui to showcase that next one, unhiding the gui
            end
        end
    end))

    function gFuncs:CreateTab(name)
        local tFr = assets.Frame.content.padding.stuf:Clone() -- this is the frame storing the content for the pages
        local tBtn = assets.Frame.content.tabs.TextButton:Clone() -- creates the tab button to easily access sections

        tBtn.Text = name
        tBtn.Parent = sFrame.content.tabs -- adds the tab button to the sidebar

        table.insert(cons, tBtn.MouseButton1Click:Connect(function()
            for _, v in tabs do -- loops through all tabs in the gui
                v.Visible = false -- hides them
                v.Parent = nil -- parents them to nil to save perf
            end
            tFr.Parent = sFrame.content.padding -- reparents the tab since it was hidden before
            tFr.Visible = true -- unhides it
        end))

        clearChildren(tFr) -- clears all the premade assets in the cloned gui asset

        local tFuncs = {
            inst = tBtn, -- returns the tab button instance incase the dev wants to modify a part of it
            fInst = tFr -- returns the tab frame
        }

        function tFuncs:CreateButton(name, callback, ...)
            local args = {...} -- takes extra arguments that might need to be passed through the button, incase you create a button with a callback of .FireServer, you need to pass the self instance for : functions to function
            local btn : TextButton = assets.Frame.content.padding.stuf.TextButton:Clone()
            local bFuncs = {
                inst = btn
            }

            btn.Text = name
            btn.Parent = tFr -- attachs the button to the tab list frame
            
            if callback then
                table.insert(cons, btn.MouseButton1Click:Connect(function() -- connects the button with the function
                    coroutine.wrap(callback)(unpack(args)) -- runs the function WITH the specified args
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
                bFuncs.Function = callback -- provides the function for the unloading and disabling process of the script
                bFuncs.Enabled = false -- state variable for dev
                table.insert(cons, btn.MouseButton1Click:Connect(function()
                    bFuncs.Enabled = not bFuncs.Enabled -- toggles the enable state
                    btn.Text = (bFuncs.Enabled and "[Enabled] " .. name) or "[Disabled] " .. name -- sets the text based off that state
                    coroutine.wrap(callback)(bFuncs.Enabled, unpack(args)) -- runs the func passing its state + arguments
                end))
            end

            table.insert(tgls, bFuncs) -- adds to the tgls table so the unload process can easily access it
            return bFuncs
        end

        tFr.Parent = ((#tabs <= 0) and sFrame.content.padding) or nil -- to save perf, we parent it to nil, so it is not rendered, this is because roblox's engine re-render's non visible frames when frame's position is updated
        tFr.Visible = (#tabs <= 0) -- checks if another tab exists, if not make the first one visible
        table.insert(tabs, tFr) -- attachs the tabs to be access easily through other functionalites
        return tFuncs
    end

    function gFuncs:Destruct()
        getgenv().zlfucker = nil
        sGui:Destroy() -- destroys the graphical element of the lib
        for _, v in cons do -- disconnects all the rbxcons, runserv, mousebuttontgls.
            if v then
                v:Disconnect()
            end
        end
        for _, v in tgls do -- loops through all the toggles
            if v.Enabled then -- checks if they are enabled
                coroutine.wrap(v.Function)(false) -- runs the function of the toggle while passing a disabled state
            end
        end
    end

    -- button for hiding/unhiding the gui, mainly for mobile
    local btn = Instance.new("TextButton", sGui)
    btn.AutoButtonColor = false
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = sFrame.BackgroundColor3
    btn.Text = "ZL"
    btn.TextScaled = true
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.AnchorPoint = Vector2.new(.5, .5)
    btn.Position = UDim2.new(0, 0, 1, 0) + UDim2.new(0, btn.Size.X.Offset * 1, 0, -(btn.Size.Y.Offset * 1)) -- calculates and positions the button based off the size

    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    btn.Visible = false
    function gFuncs:Minimize()
        btn.Visible = sFrame.Visible -- makes the button visible if the frame going to be hidden
        sFrame.Visible = not sFrame.Visible -- hides/shows the frame
        sFrame.Parent = (sFrame.Visible and sGui) or nil -- unloads/loads the frame
    end

    table.insert(cons, sFrame.top.btns.close.MouseButton1Click:Connect(gFuncs.Destruct)) -- destructs the hub through the X button, unloading the script fully
    table.insert(cons, sFrame.top.btns.mini.MouseButton1Click:Connect(gFuncs.Minimize)) -- connects the minimize button with the func
    table.insert(cons, btn.MouseButton1Click:Connect(gFuncs.Minimize)) -- does the same with the mobile open button

    if workspace.CurrentCamera and (workspace.CurrentCamera.ViewportSize - lib.mobileSize).Magnitude <= 0 then -- mobile scaling check, if the screen too small make the gui span the whole screen when opened
        sFrame.Size = UDim2.new(1, 0, 1, 0)
        -- gFuncs.Minimize()
    else
        table.insert(cons, inputServ.InputBegan:Connect(function(key, chat)
            if key.KeyCode == Enum.KeyCode.RightShift and not chat then
                gFuncs:Minimize()
            end
        end))
        -- to replace this, .Active ruins mouse input, .Draggable is stupid in the big 2025
        sFrame.Draggable = true
        sFrame.Active = true
    end

    gFuncs.inst = sGui
    gFuncs.fInst = sFrame
    return gFuncs -- returns all the functions attached in the table for creating buttons, toggles, etc.
end

return lib