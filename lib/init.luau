local lib
if dev then -- checks if the user is a developer
    export_file = "zlfucker/lib/export.rbxm" -- sets the local path to the directory of the assets file for the gui, since the user is a dev
    lib = loadfile("zlfucker/lib/gui.luau")() -- loads up the gui lib and sets the recieved table to the variable
else
    local id = genId() -- generates a id using the function that was set in the main loader
    writefile(id, request({ -- creates a file for the getcustomasset function to access
        Url = repo .. "lib/export.rbxm"
    }).Body)
    export_file = id -- sets the name of the file aka the id to the path of the file
    lib = loadstring(request({ -- loads up the lib from the web repo
        Url = repo .. "lib/gui.luau" -- refer the next file in the folder lib and the file gui.luau
    }).Body)()
    delfile(id) -- cleans up after the gui is fully loaded, to make the script basically run fileless
end

return lib