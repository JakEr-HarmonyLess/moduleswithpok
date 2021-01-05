local admin = {["Poklava"]=true,["Jaker#9310"]=true}

local maps,cmd = {1,2,3,4,5},{}

local colors = {
    teams = {
        red = "0xff0000",
        blue = "0x0004FF",
    },
}

local teams = {
    red = {},
    blue = {},
}

local room, players = tfm.get.room, tfm.get.room.playerList

function eventNewGame()
    makeTeams()
    for reders in next, teams.red do
        tfm.exec.setNameColor(reders, colors.teams.red)
    end
    for bluers in next, teams.blue do
        tfm.exec.setNameColor(bluers, colors.teams.blue)
    end
    tfm.exec.setGameTime(300)
end

function mice()
    local i = 0
    for users in next, players do
        if not players[users].isDead then
            i = i+1
        end
    end
    return i
end

function makeTeams()
    teams.red = {}
    teams.blue = {}
    local preteams,team1,team2 = {}
    for mouse in next, players do
        preteams[#preteams+1] = mouse
    end
    local n = #preteams/2
    local chance = {true,false}
    local chance = chance[math.random(#chance)]
    local team_m,team_p
    if chance then
        team_m = "red"
        team_p = "blue"
    else team_m = "blue"
        team_p = "red"
    end
    for i = 1, math.ceil(#preteams/2) do
        local num = math.random(math.ceil(#preteams/2))
        teams[team_m][preteams[num]] = true
        preteams[num] = nil
    end
    for _,people in next, preteams do
        teams[team_p][people] = true
    end
end

function eventChatCommand(p, c)
    cmd[p] = {}
    for words in c:gmatch('%S+') do
        cmd[p][#cmd[p]+1] = words
    end
    local cmd = cmd[p]
    if admin[p] then
        if cmd[1] == "map" then
            tfm.exec.newGame(maps[math.random(#maps)])
        end
    end
end

for _,f in next, {'AfkDeath','AutoShaman','MinimalistMode','WatchCommand','MortCommand','AutoNewGame'} do
    tfm.exec["disable"..f]()
end
system.disableChatCommandDisplay(nil, true)
