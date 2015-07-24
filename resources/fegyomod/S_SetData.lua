function SetKills(player,cmd,playername,kills)
if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(player)), aclGetGroup("Admin")) then  
    if playername and kills then
      local player2 = findPlayerByName(playername)
      if player2 then
       if tonumber(kills) and tonumber(kills) >= 1 then
	   setElementData( player2, "Kills",tonumber(kills))
           setAccountData ( getPlayerAccount (player2), "totalkillsdeaths.Kills", tonumber(kills))
       end
      end
    end
end
end
addCommandHandler("setk",SetKills)

function SetDeaths(player,cmd,playername,deaths)
if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(player)), aclGetGroup("Admin")) then  
    if playername and deaths then
      local player2 = findPlayerByName(playername)
      if player2 then
       if tonumber(deaths) and tonumber(deaths) >= 1 then
	   setElementData( player2, "Deaths",tonumber(deaths))
           setAccountData ( getPlayerAccount (player2), "totalkillsdeaths.Deaths", tonumber(deaths))

       end
      end
    end
end
end
addCommandHandler("setd",SetDeaths)



function findPlayerByName (name)
    local player = getPlayerFromName(name)
    if player then return player end
    for i, player in ipairs(getElementsByType("player")) do
        if string.find(string.gsub(getPlayerName(player):lower(),"#%x%x%x%x%x%x", ""), name:lower(), 1, true) then
            return player
        end
    end
return false
end



addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),
	function()
		call(getResourceFromName("scoreboard"),"addScoreboardColumn","Kills", getRootElement(), 3, 43)
		call(getResourceFromName("scoreboard"),"addScoreboardColumn","Deaths", getRootElement(), 4, 45)
		call(getResourceFromName("scoreboard"),"addScoreboardColumn","Ratio", getRootElement(), 5, 30)
	end
)