-- Have fun skidding retard.

local loopkillall
local loopkillspecifics = {}
local killnear = {}
local killnearradius = {}
local loopslapall
local loopslapspecifics = {}
local slapnear = {}
local slapnearradius = {}
local infjump

local chattext = {
    "Public SLAP ADMIN loaded! any player can now type commands",
    "kill player - Kills any player immediately.",
    "killaura on/off - Kills players around you",
    "loopkillall on/off - Enables kill all in a loop",
    "loopkill player on/off - Loop kills a player",
    "loopslapall on/off - Slaps all repeatedly",
    "loopslap player on/off - Loop slaps a player",
    "slapnear on/off radius - Slaps anybody near",
    "-- PRIVATE COMMANDS --",
    "disable - Disables public users",
    "enable - Enables public cmds",
    "infjump on/off - Infinite Jump"
}

local plrs = game:GetService("Players")
local lplayer = plrs.LocalPlayer

local admin = true

local function getslap()
    if lplayer.Character == nil then return nil end
    local slap = lplayer.Character:FindFirstChild("FreeSlap") or lplayer.Backpack.FreeSlap
    return slap
end

local function kill(player)
    if player.Character == nil then return end
    if not getslap() then return end
    if player == lplayer then return end
    local slap = getslap()
    slap.Event:FireServer("slash", player.Character, Vector3.new(0, -math.huge, 0))
end

local function slap(player)
    if player.Character == nil then return end
    if not getslap() then return end
    if player == lplayer then return end
    local slap = getslap()
    slap.Event:FireServer("slash", player.Character, Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10)))
end

local function quickfind(str)
    if str == "random" and #plrs:GetPlayers() > 1 then
        local r
        repeat 
            r = plrs:GetPlayers()[math.random(1, #plrs:GetPlayers())]
            task.wait()
        until r ~= lplayer
        return r
    end
    str = str:lower()
    for _, v in pairs(plrs:GetPlayers()) do
        local name = v.Name:lower()
        if name:find(str) then
            return v
        end
    end
    for _, v in pairs(plrs:GetPlayers()) do
        local name = v.DisplayName:lower()
        if name:find(str) then
            return v
        end
    end
end

local textchat = game:GetService("TextChatService")
local function commands()
    for i, chattext in pairs(chattext) do
        textchat.TextChannels.RBXGeneral:SendAsync(chattext)
        task.wait(0.1)
    end
end
local function findbyuserid(u)
    for i, v in pairs(plrs:GetPlayers()) do
        if v.UserId == u then
            return v
        end
    end
end

if getgenv()['Say commands when script loads'] == nil or getgenv()['Say commands when script loads'] == true then
    commands()
end

wait(1  )
textchat.MessageReceived:Connect(function(ins)
    local msg = ins.Text

    local args = msg:split(" ")
    local cmd = args[1]
    if admin == false and ins.TextSource.UserId ~= lplayer.UserId then
        return
    end
    if cmd == "disable" and admin == true then
        admin = false
        textchat.TextChannels.RBXGeneral:SendAsync("\n[Slap Admin] Now off for public users!")
    elseif cmd == "enable" and admin == false then
        admin = true
        textchat.TextChannels.RBXGeneral:SendAsync("\n[Slap Admin] Now on for public users!")
    elseif cmd == "kill" then
        local player = args[2]
        if player == "all" then
            table.foreach(plrs:GetPlayers(), function(_, p)
                kill(p)
            end)
        elseif player == lplayer.Name then
            textchat.TextChannels.RBXGeneral:SendAsync("[Slap Admin] You can't kill me! 🤣")
        else
            if quickfind(player) == nil then return end
            kill(quickfind(player))
        end
    elseif cmd == "loopkillall" then
        loopkillall = args[2] == "on" and true or args[2] == "off" and false
    elseif cmd == "loopkill" then
        local player = args[2]
        if quickfind(player) == nil then return end
        loopkillspecifics[quickfind(player)] = args[3] == "on" and true or args[3] == "off" and false
    elseif cmd == "loopslapall" then
        loopslapall = args[2] == "on" and true or args[2] == "off" and false
    elseif cmd == "loopslap" then
        local player = args[2]
        if quickfind(player) == nil then return end
        loopslapspecifics[quickfind(player)] = args[3] == "on" and true or args[3] == "off" and false
    elseif cmd == "slapnear" then
        local slapnearvalue = args[2] == "on" and true or args[2] == "off" and false
        local slapnearradiusvalue = args[3] and tonumber(args[3]) or 15

        slapnear[ins.TextSource.UserId] = slapnearvalue
        slapnearradius[ins.TextSource.UserId] = slapnearradiusvalue

        local caller = findbyuserid(ins.TextSource.UserId)
        local callername = caller.Name
        task.spawn(function()
            while slapnear[ins.TextSource.UserId] and plrs:FindFirstChild(callername) do
                if caller.Character and caller.Character:FindFirstChild("HumanoidRootPart") then
                    for i, target in pairs(plrs:GetPlayers()) do
                        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            if (target.Character.HumanoidRootPart.Position - caller.Character.HumanoidRootPart.Position).magnitude <= slapnearradius[ins.TextSource.UserId] then
                                pcall(slap, target)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    elseif cmd == "killaura" then
        local killnearvalue = args[2] == "on" and true or args[2] == "off" and false
        local killnearradiusvalue = args[3] and tonumber(args[3]) or 15

        killnear[ins.TextSource.UserId] = killnearvalue
        killnearradius[ins.TextSource.UserId] = killnearradiusvalue

        local caller = findbyuserid(ins.TextSource.UserId)
        local callername = caller.Name
        task.spawn(function()
            while killnear[ins.TextSource.UserId] and plrs:FindFirstChild(callername) do
                if caller.Character and caller.Character:FindFirstChild("HumanoidRootPart") then
                    for i, target in pairs(plrs:GetPlayers()) do
                        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            if (target.Character.HumanoidRootPart.Position - caller.Character.HumanoidRootPart.Position).magnitude <= killnearradius[ins.TextSource.UserId] then
                                pcall(kill, target)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    elseif cmd == "commands" then
        commands()
    elseif cmd == "infjump" then
        infjump = args[2] == "on" and true or args[2] == "off" and false
    end
end)

-- loop kill
task.spawn(function()
    while wait(0.3) do
        if loopslapall then
            for i, v in pairs(plrs:GetPlayers()) do
                pcall(slap, v)
            end
        end
        if loopkillall then
            for i, v in pairs(plrs:GetPlayers()) do
                pcall(kill, v)
            end
        end
        for i, v in pairs(loopkillspecifics) do
            if v == true then
                pcall(kill, i)
            end
        end
        for i, v in pairs(loopslapspecifics) do
            if v == true then
                pcall(slap, i)
            end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function ()
    if infjump then
        lplayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
