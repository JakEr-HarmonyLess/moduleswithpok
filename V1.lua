local admin = {["Poklava"]=true,["Jaker#9310"]=true}
--ui.addTextArea ( id, text, targetPlayer, x, y, width, height, backgroundColor, borderColor, backgroundAlpha, fixedPos )
local maps,cmd = {1,2,3,4,5},{}
local fixedPos = true
local mainMap = '<C><P MEDATA=";;;;-0;0:::1-"/><Z><S><S T="12" X="400" Y="200" L="10" H="400" P="0,0,0,0.2,0,0,0,0" o="324650"/><S T="9" X="13" Y="200" L="24" H="396" P="0,0,0,0,0,0,0,0"/><S T="9" X="785" Y="200" L="24" H="396" P="0,0,0,0,0,0,0,0"/><S T="12" X="131" Y="225" L="83" H="34" P="0,0,0.3,0.2,0,0,0,0" o="0617C4"/><S T="12" X="670" Y="225" L="83" H="34" P="0,0,0.3,0.2,0,0,0,0" o="AA0101"/><S T="12" X="244" Y="176" L="23" H="68" P="0,0,0.3,0.2,0,0,0,0" o="0617C4"/><S T="12" X="557" Y="176" L="23" H="68" P="0,0,0.3,0.2,0,0,0,0" o="AA0101"/><S T="12" X="326" Y="324" L="65" H="30" P="0,0,0.3,0.2,0,0,0,0" o="0617C4"/><S T="12" X="475" Y="324" L="65" H="30" P="0,0,0.3,0.2,0,0,0,0" o="AA0101"/><S T="12" X="189" Y="352" L="57" H="31" P="0,0,0.3,0.2,0,0,0,0" o="0617C4"/><S T="12" X="612" Y="352" L="57" H="31" P="0,0,0.3,0.2,0,0,0,0" o="AA0101"/><S T="12" X="98" Y="98" L="53" H="28" P="0,0,0.3,0.2,0,0,0,0" o="0617C4"/><S T="12" X="703" Y="98" L="53" H="28" P="0,0,0.3,0.2,0,0,0,0" o="AA0101"/><S T="13" X="244" Y="137" L="21" P="0,0,0,0.6,0,0,0,0" o="0617C4"/><S T="13" X="557" Y="137" L="21" P="0,0,0,0.6,0,0,0,0" o="AA0101"/><S T="12" X="397" Y="-19" L="811" H="34" P="0,0,0,0.2,0,0,0,0" o="324650" c="3" m=""/><S T="12" X="817" Y="144" L="811" H="34" P="0,0,0,0.2,90,0,0,0" o="324650" c="3" m=""/><S T="12" X="-19" Y="96" L="811" H="34" P="0,0,0,0.2,90,0,0,0" o="324650" c="3" m=""/></S><D/><O><O X="137" Y="190" C="14" P="0"/><O X="668" Y="190" C="11" P="0"/><O X="212" Y="85" C="22" P="0"/><O X="97" Y="342" C="22" P="0"/><O X="320" Y="197" C="22" P="0"/><O X="100" Y="68" C="22" P="0"/><O X="357" Y="41" C="22" P="0"/><O X="263" Y="377" C="22" P="0"/><O X="354" Y="373" C="22" P="0"/><O X="542" Y="375" C="22" P="0"/><O X="480" Y="269" C="22" P="0"/><O X="581" Y="164" C="22" P="0"/><O X="602" Y="69" C="22" P="0"/><O X="698" Y="379" C="22" P="0"/><O X="475" Y="67" C="22" P="0"/><O X="439" Y="157" C="22" P="0"/></O><L/></Z></C>'

local colors = {
    teams = {
        red = "0xff0000",
        blue = "0x0004FF",
    },
}
local game_started,spawn_points= false,0

local teams = {
    red = {
        points = {},
        spawn = {
            x,
            y,
        },
        xp = 1,
        color = "0xff0000",
        id = 1,
        players = {},
    },
    blue = {
        points = {},
        spawn = {
            x,
            y,
        },
        xp = 1,
        color = "0x0004FF",
        id = 2,
        players = {},
    },
}

local room, players = tfm.get.room, tfm.get.room.playerList
local xp_value = 10
local all_players = {}

for k in next, players do
    all_players[k] = {
        team,
        earned_xp = 0,
    }
end

function eventMouse(k, x, y)
        all_players[k] = {
            team,
            earned_xp = 0,
        }
end

function eventNewGame()
    game_started = true
    spawn_points = 0
    for k in next, players do
        all_players[k] = {
            team,
            earned_xp = 0,
        }
    end
    teams = {
        red = {
            points = {},
            text = {
                x,
                y,
            },
            spawn = {
                x,
                y,
            },
            xp = 1,
            color = "0xff0000",
            id = 1,
            players = {},
        },
        blue = {
            points = {},
            text = {
                x,
                y,
            },
            spawn = {
                x,
                y,
            },
            xp = 1,
            color = "0x0004FF",
            id = 2,
            players = {},
        },
    }
    makeTeams()
    displayXPbars()
    local xml = tfm.get.room.xmlMapInfo.xml
    xmlGetBonus(xml)
    teams.blue.spawn.x = tonumber(xml:match('<O%sX="(%d+)"%sY="%d+"%sC="14"'))
    teams.blue.spawn.y = tonumber(xml:match('<O%sX="%d+"%sY="(%d+)"%sC="14"'))
    teams.red.spawn.x = tonumber(xml:match('<O%sX="(%d+)"%sY="%d+"%sC="11"'))
    teams.red.spawn.y = tonumber(xml:match('<O%sX="%d+"%sY="(%d+)"%sC="11"'))
    for reders in next, teams.red.players do
        tfm.exec.movePlayer(reders, teams.red.spawn.x, teams.red.spawn.y)
        tfm.exec.setNameColor(reders, teams.red.color)
    end
    for bluers in next, teams.blue.players do
        tfm.exec.movePlayer(bluers, teams.blue.spawn.x,  teams.blue.spawn.y)
        tfm.exec.setNameColor(bluers, teams.blue.color)
    end
    tfm.exec.setGameTime(300)
end

function eventPlayerBonusGrabbed(player, id)
    updateXP(all_players[player].team)
end

function xmlGetBonus(xml)
    local points = {}
    for x,y in xml:gmatch('<O%sX="(%d+)"%sY="(%d+)"%sC="22"') do
        x = tonumber(x)
        y = tonumber(y)
        if x < 400 then
            teams.blue.points[#teams.blue.points+1] = "x="..x.."y="..y
        else teams.red.points[#teams.red.points+1] = "x="..x.."y="..y
        end
    end
end

function displayXPbars()
    teams.red.text.x, teams.red.text.y = 550,365
    teams.blue.text.x,teams.blue.text.y = 0,365
    for p in next, players do
        tfm.exec.addImage("1711df67b3f.png", "&0", teams.red.text.x, teams.red.text.y, p)
        ui.addTextArea ( teams.red.id, " ", p, teams.red.text.x+6, teams.red.text.y+24, teams.red.xp, 3, teams.red.color, nil, 1, fixedPos )        
        tfm.exec.addImage("1711df67b3f.png", "&0", teams.blue.text.x, teams.blue.text.y, p)
        ui.addTextArea ( teams.blue.id, " ", p, teams.blue.text.x+6, teams.blue.text.y+24, teams.blue.xp, 3, teams.blue.color, nil, 1, fixedPos )
    end
end

function updateXP(team,minus,amount)
    if not amount then
        amount = xp_value
    end
    if minus then
        teams[string.lower(team)].xp = math.max(teams[string.lower(team)].xp-amount,0)
    else teams[string.lower(team)].xp = math.min(teams[string.lower(team)].xp+amount,240)
    end
    ui.addTextArea ( teams[team].id, " ", p, teams[team].text.x+6, teams[team].text.y+24, teams[team].xp, 3, teams[team].color, nil, 1, fixedPos )
end

for _,k in next, {1,2,3,4} do
    system.bindKeyboard("Jaker#9310", k, true, true)
end

function eventKeyboard(player, key, down, x, y)
    --if all_players[player].team then
        --updateXP(all_players[player].team)
    --end
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
    teams.red.players = {}
    teams.blue.players = {}
    local preteams,team1,team2 = {}
    for mouse in next, tfm.get.room.playerList do
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
    local en = 0
    repeat
        local num = math.random(math.ceil(#preteams/2))
        if preteams[num] then
            teams[team_m].players[preteams[num]] = true
            all_players[preteams[num]].team = team_m
            preteams[num] = nil
            en = en+1
        end
    until en == math.ceil(n)
    for _,people in next, preteams do
        teams[team_p].players[people] = true
        all_players[people].team = team_p
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
            tfm.exec.newGame(mainMap)--maps[math.random(#maps)])
        end
    end
end

for _,f in next, {'AfkDeath','AutoShaman','MinimalistMode','WatchCommand','MortCommand','AutoNewGame'} do
    tfm.exec["disable"..f]()
end
system.disableChatCommandDisplay(nil, true)

--tfm.exec.addBonus(type, x, y, id, angle, visible, targetPlayer)
function eventLoop(ct, rt)
    if game_started then
        spawn_points = spawn_points+1
        if spawn_points == 6 then
            local p = teams.red.points[math.random(#teams.red.points)]
            local x,y = p:match('x=(%d+)y=(%d+)')
            x,y = tonumber(x),tonumber(y)
            tfm.exec.removeBonus(teams.red.id)
            tfm.exec.addBonus(0, x, y, teams.red.id, angle, true, everyone)
            p = teams.blue.points[math.random(#teams.blue.points)]
            local x,y = p:match('x=(%d+)y=(%d+)')
            x,y = tonumber(x),tonumber(y)
            tfm.exec.removeBonus(teams.blue.id)
            tfm.exec.addBonus(0, x, y, teams.blue.id, angle, true, everyone)
            spawn_points = 0
        end
    end
end
