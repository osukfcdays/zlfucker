local lib
if dev then
    export_file = "zlfucker/lib/export.rbxm"
    lib = loadfile("zlfucker/lib/gui.luau")()
else
    local id = genId()
    writefile(id, request({
        Url = repo .. "lib/export.rbxm"
    }).Body)
    export_file = id
    lib = loadstring(request({
        Url = repo .. "lib/gui.luau"
    }).Body)()
    delfile(id)
end

return lib