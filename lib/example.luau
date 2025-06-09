if getgenv().exampleLib then -- setup a check if the gui is running
    getgenv().exampleLib:Destruct() -- unloads the gui and all your functions you conncet inside of the lib.cons array
end

local lib = loadstring((dev and readfile("zlfucker/lib/init.luau")) or request({ -- load up the gui
    Url = "https://raw.githubusercontent.com/osukfcdays/zlfucker/refs/heads/main/lib/init.luau"
}).Body)()
local gui = lib:CreateGui("example gui") -- create your gui
getgenv().exampleLib = gui -- attach the gui for running state checks

for i = 1, 10 do
    local tab = gui:CreateTab(string.sub("tab example", 1, i)) -- create a tab, text scaling example for your tabs
    for i = 1, math.random(1, 10) do
        local btn = (math.random(1, 2) == 1 and tab:CreateButton(string.sub("button example", 1, i), function() -- creates a button, again with text scaling example
            print("this really is ONLY a button")
        end)) or tab:CreateToggle(string.sub("button example", 1, i), function(callback)
            print("yo button really gas vroo rn its in a", callback, "state")
        end)
    end
end