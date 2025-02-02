repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer or game.Players.LocalPlayer.Character
setfpscap(1000)
local Custom_Cloneref = function(org) 
    if typeof(org) ~= "Instance" then
        return org
    end

    local clone = newproxy(true)
    local mt = getmetatable(clone)

    mt.__index = org
    mt.__newindex = org
    mt.__eq = function(a, b) 
        return org == a or org == b
    end
    mt.__tostring = function()
        return tostring(org)
    end
    return mt.__newindex
end 
getgenv().Cloneref = cloneref or Custom_Cloneref or function(...) return (...) end 
local Ply = getgenv().Cloneref(game.Players.LocalPlayer)
local Rep = getgenv().Cloneref(game:GetService("ReplicatedStorage")) 
local Runs = getgenv().Cloneref(game:GetService("RunService"))
local Guis = getgenv().Cloneref(Ply:FindFirstChild("PlayerGui"))
local Tp_ser = getgenv().Cloneref(game:GetService("TeleportService"))
local https = getgenv().Cloneref(game:GetService("HttpService"))
local VirtualInputManager = getgenv().Cloneref(game:GetService("VirtualInputManager"))
getgenv().Setting = {
    Selct_marcro = nil,
    Play_marcro = false,
    Marcro_action = {'Upgrade','Target','Sell','Place'},
    Joinsraid = false,
    Replay = false
    

}

local Towerinfo = require(Rep:WaitForChild("Modules").TowerInfo)
local ReplicaHolder = require(Rep:WaitForChild("Modules").ReplicaHolder)
local function Getunit_selection()
    local Alldata = ReplicaHolder.GetReplicaOfClass("PlayerData"); -- v58
    local Data = {}; -- v59
    for v60, v61 in Alldata.Data.Slots do
        local v62 = tonumber((string.sub(v60, #v60)));
        --print(v62,v61.UnitID,v61.Value,Towerinfo[v61.Value])
       --print(v62)
        Data[v61.Value] = {
            Base = v61, 
            UnitID = v61.UnitID, 
            UnitName = v61.Value, 
            TowerInfo = Towerinfo[v61.Value]
        };
       
        local v63 = Alldata.Data.UnitData[v61.UnitID];
        if v63 and v63.EquippedSkin then
            local v64 = Alldata.Data.SkinData[v63.EquippedSkin];
            Data[v61.Value].SkinID = v63.EquippedSkin;
            if v64 then
                Data[v61.Value].SkinName = v64.SkinName;
            end;
        end;
    end;

    return Data
end
local Unit_Data = Getunit_selection()

local gnv = getgenv()
local Als_hub = "xsalarysss"
local Filename = "Laststand"
local foldername = "Marcroforuse"
local function Save_Settings()
    local suc, err = pcall(function()

        if (isfolder and makefolder) and not isfolder(foldername) then
            makefolder(foldername)
        end
        
       
        local filename = string.format("%s_%s_%s", Als_hub, tostring(Ply.Name), Filename)
        
        if writefile then
            writefile(foldername..'/'..filename..".json", https:JSONEncode(getgenv().Setting))
        end
    end)
    
    if not suc then
        warn("Failed to save settings: " .. tostring(err))
    end
end

local function Load_Settings()
    local suc, result = pcall(function()

        if (isfolder and makefolder) and not isfolder(foldername) then
            makefolder(foldername)
        end
        
        local filename = string.format("%s_%s_%s", Als_hub, tostring(Ply.Name), Filename)
        
        if (isfolder) and not isfolder(foldername..'/'.."Marcros") then
            makefolder(foldername..'/'.."Marcros")
        end
        if (isfile) and not isfile(foldername..'/'..filename..".json") then
            writefile(foldername..'/'..filename..".json", https:JSONEncode(getgenv().Setting))
            print("new write")
            return getgenv().Setting
        end
        
        print("read")
        return https:JSONDecode(readfile(foldername..'/'..filename..".json"))
    end)
    
    if suc then
        return result
    else
        return getgenv().Setting
    end
end
local function Set_Marcro_file(data,filemarcro_names)
    local suc,err = pcall(function()
        if (isfolder and makefolder) and not isfolder(foldername) then
            makefolder(foldername)
        end
        if (isfolder) and not isfolder(foldername..'/'.."Marcros") then
            makefolder(foldername..'/'.."Marcros")
        end

        if writefile then
            writefile(foldername..'/'.."Marcros"..'/'..tostring(filemarcro_names)..".json", https:JSONEncode(data))
        end
    end)
end
local function Load_marcro_file(filemarcro_names)
    local suc,res = pcall(function()
        if (isfolder and makefolder) and not isfolder(foldername) then
            makefolder(foldername)
        end
        if (isfolder) and not isfolder(foldername..'/'.."Marcros") then
            makefolder(foldername..'/'.."Marcros")
        end

        return https:JSONDecode(readfile(foldername..'/'.."Marcros"..'/'..tostring(filemarcro_names)..".json"))
    end)
    if suc then
        return res
    else
        return nil
    end
end

local function Load_macro_list()
    local suc, res = pcall(function()
        if (isfolder and makefolder) and not isfolder(foldername) then
            makefolder(foldername)
        end
        if (isfolder) and not isfolder(foldername .. '/' .. "Marcros") then
            makefolder(foldername .. '/' .. "Marcros")
        end
        if listfiles then
            return listfiles(foldername .. '/' .. "Marcros")
        end
    end)

    if suc then
        local filenames = {}
        for _, v in pairs(res) do
            local name = v:match("([^/\\]+)$")
            local filrpart = name:match("(.+)%..+$") or name 
            table.insert(filenames, filrpart)
        end
        return filenames
    else
        return nil
    end
end



getgenv().Setting = Load_Settings()

local All_marcro = Load_macro_list() or {}
local Marcro_name = nil
local Isrecording = false
local Marcro_forsave = {}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dukdik234/SaveUi/refs/heads/main/Save_Ui.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dukdik234/SaveUi/refs/heads/main/Interface.lua"))()
local Ui_manager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dukdik234/Ui_managers/refs/heads/main/Main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Als" .." ".. " " .. "Marcro",
    SubTitle = "By Oxegen",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

local ImageLabel = Instance.new("ImageLabel") 
ImageLabel.Parent = Window.TitleBar.Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0
ImageLabel.Size = UDim2.new(0, 45, 0, 45) 
ImageLabel.ImageTransparency = 0
ImageLabel.AnchorPoint = Vector2.new(.8, 0.5) 
ImageLabel.Position = UDim2.new(0.4, 0, 0.5, 0) 
ImageLabel.Image = "rbxassetid://109557005690410"
ImageLabel.ZIndex = 1 
Ui_manager:Cleanui()
local Mainui = Ui_manager:Make_maingui()

local But = Ui_manager:Make_closeuibut(function()
    Window.Minimize()
end)
local Options = Fluent.Options
--https://lucide.dev/icons/
local Tabs = {
    Main = Window:AddTab({ Title = "Plays", Icon = "play" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

Tabs.Main:AddSection("Marcro")
local Dropdown = Tabs.Main:AddDropdown("marcrotabs", {
    Title = "Select Marcros",
    Values = All_marcro,
    Multi = false,
    Default = getgenv().Setting.Selct_marcro,
})

Dropdown:OnChanged(function(Value)
    getgenv().Setting.Selct_marcro = Options.marcrotabs.Value
    --Save_Settings()
end)
local marcrofilename_in = Tabs.Main:AddInput("marcrofilename_ins", {
    Title = "Create Marcrofile",
    Default = "",
    Placeholder = "Create Marcrofile Name",
    Numeric = false,
    Finished = false, 
})

marcrofilename_in:OnChanged(function()
    Marcro_name = marcrofilename_in.Value
end)
Tabs.Main:AddButton({
    Title = "Create Marcro",
    Description = "Click to create marcrofile",
    Callback = function()
        Set_Marcro_file({},Marcro_name)
        Fluent:Notify({
            Title = Als_hub,
            Content = tostring(Marcro_name).." ".." Is Create",
            Duration = 8
        })
    end
})
Tabs.Main:AddButton({
    Title = "Refesh Marcro File",
    Description = "Click to Refesh Marcro File",
    Callback = function()
        Dropdown:SetValues(Load_macro_list() or {})
    end
})
--Set_Marcro_file
--[[
    for _,v in pairs(Tabs.Main:AddParagraph({Title = "123",Content="asd"})) do
        print(_,v)
    end

    SetDesc
    🟢
    🔴🟠🟡🟢🔵🟣⚫️⚪️🟤
]]
Tabs.Main:AddSection("Record")
local Record_state = Tabs.Main:AddParagraph({
    Title = "Marcro Recording".." : ".." 🔴 ",
    Content = "This is Marcro Is Recording State"
})
local marcroaction_drop = Tabs.Main:AddDropdown("marcroaction_drops", {
    Title = "Select Marcros Actions",
    Values = {'Upgrade','Target','Sell','Place'},
    Multi = true,
    Default = getgenv().Setting.Marcro_action,
})

marcroaction_drop:OnChanged(function(Value)
    local Values = {}
    for Value, State in next, Value do
        table.insert(Values, Value)
    end
    getgenv().Setting.Marcro_action = Values
    --Save_Settings()
end)
local recording = Tabs.Main:AddToggle("recordings", {Title = "Recording", Default = Isrecording })
recording:OnChanged(function()
    Isrecording = Options.recordings.Value

    
    if getgenv().Setting.Selct_marcro and not game.Workspace:FindFirstChild("Lobby") then
        if Options.recordings.Value then
            Record_state:SetTitle("Marcro Recording".." : ".." 🟢 ")
        else
            Record_state:SetTitle("Marcro Recording".." : ".." 🔴 ")
            print("Save recording")
            Set_Marcro_file(Marcro_forsave[getgenv().Setting.Selct_marcro],getgenv().Setting.Selct_marcro)
        end
    end
    --Save_Settings()
end)
Tabs.Main:AddSection("Play")
local Plays_state = Tabs.Main:AddParagraph({
    Title = "Marcro Is Playing".." : ".." 🔴 ",
    Content = "This is Marcro Playing State "
})
local play_marcro = Tabs.Main:AddToggle("play_marcros", {Title = "Play Marcro", Default = getgenv().Setting.Play_marcro })
play_marcro:OnChanged(function()
    getgenv().Setting.Play_marcro = Options.play_marcros.Value

    --Save_Settings()
end)
Tabs.Main:AddSection("Games")
local join_raid = Tabs.Main:AddToggle("join_raids", {Title = "Joins Raids", Default = getgenv().Setting.Joinsraid })
join_raid:OnChanged(function()
    getgenv().Setting.Joinsraid = Options.join_raids.Value
    if getgenv().Tp_door then
        getgenv().Tp_door = false
    end

    Save_Settings()
end)
local replays = Tabs.Main:AddToggle("replayss", {Title = "Replay", Default = getgenv().Setting.Replay })
replays:OnChanged(function()
    getgenv().Setting.Replay = Options.replayss.Value

    Save_Settings()
end)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({})


InterfaceManager:SetFolder(Als_hub)
SaveManager:SetFolder(Als_hub)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = Als_hub,
    Content = "The script has been loaded.",
    Duration = 8
})

getgenv().Tp_door = false
local Tp = function(Pos)
    local Char = Ply.Character
    if Char 
        and Char:FindFirstChild("HumanoidRootPart") then
        Char:FindFirstChild("HumanoidRootPart").CFrame = Pos
    end
end
task.spawn(function()
    --pcall(function()
        while wait() do
            if getgenv().Setting.Joinsraid then
                local Doors = nil
                for _, lobby in pairs(workspace.TeleporterFolder.Raids:GetChildren()) do
                    local door = lobby:FindFirstChild("Door")
                    if door and door:FindFirstChild("UI") then
                        --print(door.UI.PlayerCount.Text)
                        if tonumber(string.match(door.UI.PlayerCount.Text, "%d+")) == 0 then
                            Doors = lobby
                            break
                        end
                    end
                end
                if Doors 
                    and not getgenv().Tp_door then
                        Tp(Doors:FindFirstChild("Door").CFrame)
                        getgenv().Tp_door = true
                        task.wait(.5)

                end
                task.wait(1)
                task.spawn(function()
                    
                    if getgenv().Setting.Tp_door 
                        and getgenv().Setting.Joinsraid then
                            local args = {
                                "Central City",
                                6,
                                "Nightmare",
                                true
                            }
                            game:GetService("ReplicatedStorage").Remotes.Raids.Select:InvokeServer(unpack(args))
                
                            task.wait()
                            game:GetService("ReplicatedStorage").Remotes.Teleporter.Interact:FireServer("Skip")
                    end
                end)
            end
        end
    --end)
end)
--game:GetService("ReplicatedStorage").GameEnded
local GuiService = game:GetService("GuiService")
coroutine.resume(coroutine.create(function()
    task.spawn(function()
        --pcall(function()
            if not game.Workspace:FindFirstChild("Lobby") then
                local Values = Rep:FindFirstChild("GameEnded")
                
                local function replay()
                    if getgenv().Setting.Replay and 
                        Values.Value == true then 
                            if not Guis:FindFirstChild("EndGameUI") then return end
                            local button = Guis:FindFirstChild("EndGameUI").BG.Buttons.Retry
                            if button then
                                repeat task.wait()
                                    --print('click')
                                    task.wait(0.2)
                                    GuiService.SelectedObject = button
                                    if GuiService.SelectedObject == button then
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                    end
                                    task.wait(0.1)
                                    GuiService.SelectedObject = nil
                                    --print('enfd')
                                until not Guis:FindFirstChild("EndGameUI")
                                GuiService.SelectedObject = nil
                            end
                    end
                end
                Values:GetPropertyChangedSignal("Value"):Connect(replay)
                while wait() do
                    if Values and Values.Value == true then
                        replay()
                    end
                end
            end
        --end)
    end)
end))






local current_index = 1

task.spawn(function()
    while wait() do
        if getgenv().Setting.Play_marcro and getgenv().Setting.Selct_marcro then
            local Load_marcro = Load_marcro_file(getgenv().Setting.Selct_marcro)
            local Game_time = Rep:FindFirstChild("ElapsedTime").Value or 0
            local Money = Ply.Cash.Value
            local Wave = Rep:FindFirstChild("Wave").Value or 1

            local function wait_money(required)
                while Money < required do
                    task.wait(0.1)
                    return false
                end
                return true
            end

            if current_index <= Load_marcro.index then
                Plays_state:SetTitle("Marcro Is Playing".." : ".." 🟢 ")
                
                for _, v in pairs(Load_marcro.Actions) do
                    if tonumber(v.Data.index) == current_index then
                        if v.Data.Method then
                            local args = {}
                            for _, arg in pairs(v.Data.Args) do
                                if arg.Type == "string" then
                                    table.insert(args, arg.Value)
                                elseif arg.Type == "CFrame" then
                                    table.insert(args, CFrame.new(unpack(arg.Value)))
                                end
                            end

                            local part = Rep.Remotes:FindFirstChild(v.Data.action)
                            
                            if part then
                                if v.Data.action == "PlaceTower" and tonumber(Wave) >= tonumber(v.Data.Wave) then
                                    local cost = Unit_Data[args[1]].TowerInfo[0]['Cost']
                                    if not wait_money(cost) then
                                        
                                    end
                                    part[v.Data.Method](part, unpack(args))

                                elseif v.Data.action == "Upgrade" and tonumber(Wave) >= tonumber(v.Data.Wave) then
                                    local unit_parent = workspace.Towers:FindFirstChild(tostring(args[1]))
                                    part[v.Data.Method](part, unit_parent)

                                elseif v.Data.action == "ChangeTargeting" and tonumber(Wave) >= tonumber(v.Data.Wave) then
                                    local unit_parent = workspace.Towers:FindFirstChild(tostring(args[1]))
                                    part[v.Data.Method](part, unit_parent)

                                elseif v.Data.action == "Sell" and tonumber(Wave) >= tonumber(v.Data.Wave) then
                                    local unit_parent = workspace.Towers:FindFirstChild(tostring(args[1]))
                                    part[v.Data.Method](part, unit_parent)
                                end
                            end
                        end
                    end
                end


                current_index = current_index + 1
                task.wait()
            else

                current_index = 1
                --Plays_state:SetTitle("Marcro Is Playing".." : ".." 🔴 ")
                --break
            end
        end
    end
end)

local function GetInstancePath(obj)
    local ffc = game:GetService("RunService").Parent.FindFirstChild
    local getCh = game:GetService("RunService").Parent.GetChildren
    local ts = tostring
    local match = string.match
    local gsub = string.gsub
    local tableFind = table.find
    local useGetChildren = true  


    if not obj or typeof(obj) ~= "Instance" then
        return nil
    end

    local path = ""
    local current = obj

    local function formatLuaString(str)
        return (gsub(str, '["\\\n\r\t]', {
            ['"'] = '\\"',
            ['\\'] = '\\\\',
            ['\n'] = '\\n',
            ['\r'] = '\\r',
            ['\t'] = '\\t'
        }))
    end

    while current do
        if current == game then
            path = "game" .. path
            break
        end

        local className = current.ClassName
        local curName = ts(current)
        local indexName


        if match(curName, "^[%a_][%w_]*$") then
            indexName = "." .. curName
        else
            local cleanName = formatLuaString(curName)
            indexName = '["' .. cleanName .. '"]'
        end

        local parent = current.Parent
        if parent then

            if useGetChildren then
                local firstChild = ffc(parent, curName)
                if firstChild and firstChild ~= current then
                    local children = getCh(parent)
                    local index = tableFind(children, current)
                    if index then
                        indexName = ":GetChildren()[" .. index .. "]"
                    end
                end
            end

           
            if parent == game and className and ({
                Workspace = true,
                Players = true,
                Lighting = true,
                ReplicatedStorage = true,
                ServerScriptService = true,
                ServerStorage = true,
                StarterGui = true,
                StarterPack = true,
                StarterPlayer = true,
                Teams = true,
                SoundService = true,
                Chat = true,
                LocalizationService = true,
                TestService = true
            })[className] then
                indexName = ':GetService("' .. className .. '")'
            end
        elseif parent == nil then

            local nilTemplate = [[local getNil = function(name, class) 
                for _, v in next, getnilinstances() do 
                    if v.ClassName == class and v.Name == name then 
                        return v 
                    end 
                end 
            end]]
            local nilFormat = "\n\ngetNil(\"%s\", \"%s\")"
            indexName = nilTemplate .. nilFormat:format(current.Name, className)
        end

        path = indexName .. path
        current = parent
    end


    if not path:match("^game") then
        path = "game" .. path
    end

    return path
end
coroutine.resume(coroutine.create(function()
    local Action = {
        ['Upgrade'] = {Data = "Upgrade"},
        ['Target'] = {Data = "ChangeTargeting"},
        ['Sell']   = {Data = "Sell"},
        ['Place']  = {Data = "PlaceTower"},

    }
    local Hook_action
    local Game_time = Rep:FindFirstChild("ElapsedTime") or 0
    local Mapname = workspace:FindFirstChild("Map").MapName or nil
    local Wave = Rep:FindFirstChild("Wave") or 1
    local function Tower_add(value)
        local towers = game.Workspace:WaitForChild("Towers")
    

        for _, tower in pairs(towers:GetChildren()) do
            local owner = tower:FindFirstChild("Owner")
            if tower.Name == value  then
                print(GetInstancePath(tower))
                return GetInstancePath(tower)
            end
        end
    

        return coroutine.wrap(function()
            local result
            local connection
            connection = towers.ChildAdded:Connect(function(tower)
                local owner = tower:FindFirstChild("Owner") 
                if tower.Name == value then
                    result = GetInstancePath(tower)
                    connection:Disconnect()
                    coroutine.yield(result)
                    
                end
            end)
    
            coroutine.yield(nil) 
        end)()
    end
    
    
    --local Arguments = {}
    Hook_action = hookfunction(getrawmetatable(getgenv().Cloneref(game)).__namecall, function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
    
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            task.spawn(function()
                if getgenv().Setting.Selct_marcro and not game.Workspace:FindFirstChild("Lobby") and Isrecording then
                    for _, v in pairs(getgenv().Setting.Marcro_action) do
                        if Action[v] and tostring(self) == Action[v].Data then
                            print("addindex: " .. tostring(self),"Time :", Game_time.Value , unpack(args))
                            
                            if not Marcro_forsave[getgenv().Setting.Selct_marcro] then
                                Marcro_forsave[getgenv().Setting.Selct_marcro] = {
                                    index = 0,
                                    Actions = {},
                                    Map = Mapname.Value
                                }
                            end
                            Marcro_forsave[getgenv().Setting.Selct_marcro].index = Marcro_forsave[getgenv().Setting.Selct_marcro].index + 1
                            local Arguments = {}
                            for _,arg in pairs(args) do
                                if typeof(arg) == "CFrame" then
                                    table.insert(Arguments,{ Value = { arg:GetComponents() }, Type = "CFrame" })
                                else
                                    table.insert(Arguments, { Value = tostring(arg), Type = "string" })
                                end
                            end
                            table.insert(Marcro_forsave[getgenv().Setting.Selct_marcro].Actions, {
                                Data = {
                                    index = Marcro_forsave[getgenv().Setting.Selct_marcro].index,
                                    action = tostring(self),
                                    Args = Arguments,
                                    Method = method,
                                    Wave = Wave.Value
                                },
                                Time = Game_time.Value
                            })
                        end
                    end
                    
                end
            end)
        end
    
        return Hook_action(self, unpack(args))
    end)
   
end))


--[[

    local ohString1 = "Ichigo (Bankai)"
    local ohCFrame2 = CFrame.new(-135.791412, 197.939423, 5.17110825, 1, 0, 0, 0, 1, 0, 0, 0, 1)

    game:GetService("ReplicatedStorage").Remotes.PlaceTower:FireServer(ohString1, ohCFrame2)

    local ohInstance1 = workspace.Towers["Ichigo (Bankai)"]

    game:GetService("ReplicatedStorage").Remotes.Upgrade:InvokeServer(ohInstance1)

    local ohInstance1 = workspace.Towers["Ichigo (Bankai)"]

    game:GetService("ReplicatedStorage").Remotes.ChangeTargeting:InvokeServer(ohInstance1)

    -- This script was generated by Hydroxide's RemoteSpy: https://github.com/Upbolt/Hydroxide

    local ohInstance1 = workspace.Towers["Ichigo (Bankai)"]

    game:GetService("ReplicatedStorage").Remotes.Sell:InvokeServer(ohInstance1)
]]
