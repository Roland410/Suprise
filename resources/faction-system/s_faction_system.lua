mysql = exports.mysql

-- EVENTS
addEvent("onPlayerJoinFaction", false)
addEventHandler("onPlayerJoinFaction", getRootElement(),
	function(theTeam)
		return
	end
)

function loadAllFactions(res)
	local result = mysql:query("SELECT * FROM factions ORDER BY id ASC")
	local counter = 0
	
	if result then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			local id = tonumber(row.id)
			local name = row.name
			local money = tonumber(row.bankbalance)
			local factionType = tonumber(row.type)
			
			local theTeam = createTeam(tostring(name))
			exports.pool:allocateElement(theTeam, id)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "type", factionType, true)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "money", money, false)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "id", id, true)
			
			local factionRanks = {}
			local factionWages = {}
			for i = 1, 20 do
				factionRanks[i] = row['rank_'..i]
				factionWages[i] = tonumber(row['wage_'..i])
			end
			local motd = row.motd
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "ranks", factionRanks, false)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "wages", factionWages, false)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "motd", motd, false)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "note", row.note == mysql_null() and "" or row.note, false)
			
			counter = counter + 1
		end
		mysql:free_result(result)
		
		local citteam = createTeam("Citizen", 255, 255, 255)
		exports.pool:allocateElement(citteam, -1)
		
		-- set all players into their appropriate faction
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			local username = getPlayerName(thePlayer)
			local safeusername = mysql:escape_string(username)
			
			local result = mysql:query_fetch_assoc("SELECT faction_id, faction_rank, faction_leader, faction_perks FROM characters WHERE charactername='" .. safeusername .. "' LIMIT 1")
			if result then
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionMenu", 0, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "faction", tonumber(result.faction_id), false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionrank", tonumber(result.faction_rank), false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionleader", tonumber(result.faction_leader), false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionPackages", fromJSON(result.faction_perks) or { }, false)
				
				setPlayerTeam(thePlayer, exports.pool:getElement("team", result.faction_id) or citteam)
			end
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllFactions)

function hasPlayerAccessOverFaction(theElement, factionID)
	if (isElement(theElement)) then	-- Is the player online?
		local realFactionID = getElementData(theElement, "faction") or -1
		local factionLeaderStatus = getElementData(theElement, "factionleader") or 0
		if tonumber(realFactionID) == tonumber(factionID) then -- Is the player in the specific faction
			if tonumber(factionLeaderStatus) == 1 then -- Is the player a faction leader?
				return true
			end
		end
	end
	return false
end

-- returns stateid, factionid, factionrank, factionleader, table with factionperks, element of player if applicable
-- stateid 0: Online, stateid 1: Offline, stateid 2: Not found
function getPlayerFaction(playerName)
	local thePlayerElement = getPlayerFromName(playerName)
	local override = false
	if (thePlayerElement) then -- Player is online
		if (getElementData(thePlayerElement, "loggedin") ~= 1) then
			override = true
		else
			local playerFaction = getElementData(thePlayerElement, "faction")
			local playerFactionRank = getElementData(thePlayerElement, "factionrank")
			local playerFactionLeader = getElementData(thePlayerElement, "factionleader")
			local playerFactionPerks = getElementData(thePlayerElement, "factionPackages")
			
			return 0, playerFaction, playerFactionRank, playerFactionLeader, playerFactionPerks, thePlayerElement
		end
	end
	
	if (not thePlayerElement or override) then  -- Player is offline
		local row = mysql:query_fetch_assoc("SELECT faction_id, faction_rank, faction_perks, faction_leader FROM characters WHERE charactername='" .. mysql:escape_string(playerName) .. "'")
		if row then
			return 1, tonumber(row["faction_id"]), tonumber(row["faction_rank"]), tonumber(row["faction_leader"]), (fromJSON(row["faction_perks"]) or { }), nil
		end
	end
	
	return 2, -1, 20, 0, { }, nil -- Player was not found
end

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "F3", "down", showFactionMenu)) then
			bindKey(arrayPlayer, "F3", "down", showFactionMenu)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F3", "down", showFactionMenu)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showFactionMenu(source)
	local logged = getElementData(source, "loggedin")
	
	if (logged==1) then
		local menuVisible = getElementData(source, "factionMenu")
		
		if (menuVisible==0) then
			local factionID = getElementData(source, "faction")
			
			if (factionID~=-1) then
				local theTeam = getPlayerTeam(source)
				local query = mysql:query("SELECT charactername,  faction_rank, faction_perks, faction_leader, DATEDIFF(NOW(), lastlogin) AS lastlogin FROM characters WHERE faction_ID='" .. factionID .. "' ORDER BY faction_rank DESC, charactername ASC")
				if query then
					
					local memberUsernames = {}
					local memberRanks = {}
					local memberLeaders = {}
					local memberOnline = {}
					local memberLastLogin = {}
					local memberLocation = {}
					local memberPerks = {}
					local factionRanks = getElementData(theTeam, "ranks")
					local factionWages = getElementData(theTeam, "wages")
					local motd = getElementData(theTeam, "motd")
					local note = hasPlayerAccessOverFaction(source, factionID) and getElementData(theTeam, "note") or "no u"
					
					if (motd == "") then motd = nil end
					
					local i = 1
					while true do
						local row = mysql:fetch_assoc(query)
						if not row then break end
						
						local playerName = row.charactername
						memberUsernames[i] = playerName
						memberRanks[i] = row.faction_rank
						memberPerks[i] = fromJSON(row.faction_perks) or { }
						
						if (tonumber(row.faction_leader)==1) then
							memberLeaders[i] = true
						else
							memberLeaders[i] = false
						end
						
						local login = ""
						
						memberLastLogin[i] = tonumber(row.lastlogin)
						
						
						local targetPlayer = getPlayerFromName(tostring(playerName))
						if (targetPlayer) then
							local onlineState = getElementData(targetPlayer, "loggedin")
							if (onlineState == 1) then
								memberOnline[i] = true
							end
						else
							memberOnline[i] = false
						end
						memberLocation[i] = "Ismeretlen"
						i = i + 1
					end
					exports['anticheat-system']:changeProtectedElementDataEx(source, "factionMenu", 1, false)
					mysql:free_result(query)
					
					local theTeam = getPlayerTeam(source)
					triggerClientEvent(source, "showFactionMenu", getRootElement(), motd, memberUsernames, memberRanks, hasPlayerAccessOverFaction(source, factionID) and memberPerks or {}, memberLeaders, memberOnline, memberLastLogin, memberLocation, factionRanks,  factionWages, theTeam, note)
				end
			else
				outputChatBox("Nem vagy frakcióban.", source)
			end
		else
			triggerClientEvent(source, "hideFactionMenu", getRootElement())
		end
	end
end

-- // CALL BACKS FROM CLIENT GUI
function callbackUpdateRanks(ranks, wages)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
	
	for key, value in ipairs(ranks) do
		ranks[key] = mysql:escape_string(ranks[key])
	end
	
	if (wages) then
		for i = 1, 20 do
			wages[i] = math.min(25000, math.max(0, tonumber(wages[i]) or 0))
		end
		
		mysql:query_free("UPDATE factions SET wage_1='" .. wages[1] .. "', wage_2='" .. wages[2] .. "', wage_3='" .. wages[3] .. "', wage_4='" .. wages[4] .. "', wage_5='" .. wages[5] .. "', wage_6='" .. wages[6] .. "', wage_7='" .. wages[7] .. "', wage_8='" .. wages[8] .. "', wage_9='" .. wages[9] .. "', wage_10='" .. wages[10] .. "', wage_11='" .. wages[11] .. "', wage_12='" .. wages[12] .. "', wage_13='" .. wages[13] .. "', wage_14='" .. wages[14] .. "', wage_15='" .. wages[15] .. "', wage_16='" .. wages[16] .. "', wage_17='" .. wages[17] .. "', wage_18='" .. wages[18] .. "', wage_19='" .. wages[19] .. "', wage_20='" .. wages[20] .. "' WHERE id='" .. factionID .. "'")
		exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "wages", wages, false)
	end
	
	mysql:query_free("UPDATE factions SET rank_1='" .. ranks[1] .. "', rank_2='" .. ranks[2] .. "', rank_3='" .. ranks[3] .. "', rank_4='" .. ranks[4] .. "', rank_5='" .. ranks[5] .. "', rank_6='" .. ranks[6] .. "', rank_7='" .. ranks[7] .. "', rank_8='" .. ranks[8] .. "', rank_9='" .. ranks[9] .. "', rank_10='" .. ranks[10] .. "', rank_11='" .. ranks[11] .. "', rank_12='" .. ranks[12] .. "', rank_13='" .. ranks[13] .. "', rank_14='" .. ranks[14] .. "', rank_15='" .. ranks[15] .. "', rank_16='" .. ranks[16] .. "', rank_17='" .. ranks[17] .. "', rank_18='" .. ranks[18] .. "', rank_19='" .. ranks[19] .. "', rank_20='" .. ranks[20] .. "' WHERE id='" .. factionID .. "'")
	exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "ranks", ranks, false)
	
	outputChatBox("A frakció információi sikeresen frissítve.", source, 0, 255, 0)
	showFactionMenu(source)
end
addEvent("cguiUpdateRanks", true )
addEventHandler("cguiUpdateRanks", getRootElement(), callbackUpdateRanks)


function callbackRespawnVehicles()
	local theTeam = getPlayerTeam(source)
	
	local factionCooldown = getElementData(theTeam, "cooldown")
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
		
	if not (factionCooldown) then
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			local faction = getElementData(value, "faction")
			if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
				respawnVehicle(value)
			end
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		local username = getPlayerName(source)
		for k, v in ipairs(teamPlayers) do
			outputChatBox(username .. " helyrerakta a használatlan frakció járműveket.", v)
		end

		setTimer(resetFactionCooldown, 600000, 1, theTeam)
		exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "cooldown", true, false)
	else
		outputChatBox("Jelenleg nem tudod helyrerakni a frakció járműveket, kérlek várj...", source, 255, 0, 0)
	end
end
addEvent("cguiRespawnVehicles", true )
addEventHandler("cguiRespawnVehicles", getRootElement(), callbackRespawnVehicles)

function resetFactionCooldown(theTeam)
	exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "cooldown")
end

function callbackUpdateMOTD(motd)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if mysql:query_free("UPDATE factions SET motd='" .. tostring(mysql:escape_string(motd)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("Megváltoztattad a napi üzenetet erre: '" .. motd .. "'", client, 0, 255, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "motd", motd, false)
		else
			outputChatBox("Error 300000 - Jelentsd fórumon.", client, 255, 0, 0)
		end
	end
end
addEvent("cguiUpdateMOTD", true )
addEventHandler("cguiUpdateMOTD", getRootElement(), callbackUpdateMOTD)

function callbackUpdateNote(note)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) or not note then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if mysql:query_free("UPDATE factions SET note='" .. tostring(mysql:escape_string(note)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("Megváltoztattad a leader jegyzetet.", client, 0, 255, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "note", note, false)
		else
			outputChatBox("Error 30000A - Jelentsd fórumon.", client, 255, 0, 0)
		end
	end
end
addEvent("faction:note", true )
addEventHandler("faction:note", getRootElement(), callbackUpdateNote)

function callbackRemovePlayer(removedPlayerName)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end

	local targetFactionInfo = {getPlayerFaction(removedPlayerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Nem fog működni.", client)
		return
	end
	
	if mysql:query_free("UPDATE characters SET faction_id='-1', faction_leader='0', faction_rank='1', dutyskin = 0, duty = 0 WHERE charactername='" .. mysql:escape_string(removedPlayerName) .. "'") then
		local theTeam = getPlayerTeam(client)
		local theTeamName = "Nincs"
		if (theTeam) then
			theTeamName = getTeamName(theTeam)
		end
		
		local username = getPlayerName(client)
		

		local removedPlayer = getPlayerFromName(removedPlayerName)
		if (removedPlayer) then -- Player is online
			if (getElementData(client, "factionMenu")==1) then
				triggerClientEvent(removedPlayer, "hideFactionMenu", getRootElement())
			end
			outputChatBox(username .. " kirúgott a frakcióból.", removedPlayer)
			setPlayerTeam(removedPlayer, getTeamFromName("Citizen"))
			exports['anticheat-system']:changeProtectedElementDataEx(removedPlayer, "faction", -1, false)
			exports['anticheat-system']:changeProtectedElementDataEx(removedPlayer, "dutyskin", -1, false)
			exports['anticheat-system']:changeProtectedElementDataEx(removedPlayer, "factionleader", 0, false)
			triggerEvent("duty:offduty", removedPlayer)
			--triggerClientEvent(removedPlayer, "updateFactionInfo", removedPlayer, -1, 1)
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		for k, v in ipairs(teamPlayers) do
			if (v ~= removedPlayer) then
				outputChatBox(username .. " kirúgta " .. removedPlayerName .. "-t .", v)
			end
		end
	else
		outputChatBox("Nem tudod kirúgni " .. removedPlayerName .. "-t a frakcióból, keress fel egy admint.", source, 255, 0, 0)
	end
end
addEvent("cguiKickPlayer", true )
addEventHandler("cguiKickPlayer", getRootElement(), callbackRemovePlayer)

function callbackPerkEdit( perkIDTable, playerName)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Nem fog működni.", client)
		return
	end
	
	local jsonPerkIDTable = toJSON( perkIDTable )
	if mysql:query_free("UPDATE `characters` SET `faction_perks`='" .. mysql:escape_string(jsonPerkIDTable) .. "' WHERE `charactername`='" .. mysql:escape_string(playerName) .. "'") then
		outputChatBox(" Átállítottad "..playerName:gsub("_", " ").." felszerelés jogosultságait.", client, 255, 0, 0)
		local targetPlayer = getPlayerFromName(playerName)
		if targetPlayer then
			setElementData(targetPlayer, "factionPackages", perkIDTable)
			outputChatBox(" A felszereléshez való jogosultságaidat megváltoztatta "..getPlayerName(client):gsub("_", " ") .. ".", targetPlayer, 255, 0, 0)
		end
	end
end
addEvent("faction:perks:edit", true)
addEventHandler("faction:perks:edit", getRootElement(), callbackPerkEdit)


function callbackToggleLeader(playerName, isLeader)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Nem fog működni.", client)
		return
	end
	
	if (isLeader) then -- Make player a leader
		local username = getPlayerName(client)
		if mysql:query_free("UPDATE characters SET faction_leader='1' WHERE charactername='" .. mysql:escape_string(playerName) .. "'") then

			-- Send message to everyone in the faction
			local theTeam = getPlayerTeam(client)
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " kinevezte " .. playerName .. "-t leadernek.", v)
			end
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionleader", 1, true)
			end
		else
			outputChatBox("Nem lehet előléptetni " .. removedPlayerName .. "-t leaderré, vedd fel a kapcsolatot egy adminnal.", client, 255, 0, 0)
		end
	else
		local username = getPlayerName(client)
		if mysql:query_free("UPDATE characters SET faction_leader='0' WHERE charactername='" .. mysql:escape_string(playerName) .. "'") then
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				if (getElementData(client, "factionMenu")==1) then
					triggerClientEvent(thePlayer, "hideFactionMenu", getRootElement())
				end
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionleader", 0, true)
			end
			
			-- Send message to everyone in the faction
			local theTeam = getPlayerTeam(client)
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " elvette " .. playerName .. " leaderét.", v)
			end
		else
			outputChatBox("Nem lehet elvenni " .. removedPlayerName .. " leaderét, vedd fel a kapcsolatot egy adminnal.", client, 255, 0, 0)
		end
	end
end
addEvent("cguiToggleLeader", true )
addEventHandler("cguiToggleLeader", getRootElement(), callbackToggleLeader)

function callbackPromotePlayer(playerName, rankNum, oldRank, newRank)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Nem fog működni.", client)
		return
	end
	
	local username = getPlayerName(client)
	if mysql:query_free("UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. mysql:escape_string(playerName) .. "'") then
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, set his rank
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionrank", rankNum, false)
		end
		
		-- Send message to everyone in the faction
		local theTeam = getPlayerTeam(client)
		if (theTeam) then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " előléptette " .. playerName .. "-t erről: '" .. oldRank .. "' erre: '" .. newRank .. "'.", v)
			end
		end
	else
		outputChatBox("Nem lehet " .. removedPlayerName .. "-t előléptetni, keress fel egy admint.", client, 255, 0, 0)
	end
end
addEvent("cguiPromotePlayer", true )
addEventHandler("cguiPromotePlayer", getRootElement(), callbackPromotePlayer)

function callbackDemotePlayer(playerName, rankNum, oldRank, newRank)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Nem fog működni.", client)
		return
	end
	
	local username = getPlayerName(client)
	local safename = mysql:escape_string(playerName)
	
	if mysql:query_free("UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. safename .. "'") then
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, tell them
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "factionrank", rankNum, false)
		end
		
		-- Send message to everyone in the faction
		local theTeam = getPlayerTeam(client)
		if (theTeam) then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " lefokozta " .. playerName .. "-t erről: '" .. oldRank .. "' erre: '" .. newRank .. "'.", v)
			end
		end
	else
		outputChatBox("Nem lehet " .. removedPlayerName .. "-t lefokozni keress fel egy admint.", client, 255, 0, 0)
	end
end
addEvent("cguiDemotePlayer", true )
addEventHandler("cguiDemotePlayer", getRootElement(), callbackDemotePlayer)

function callbackQuitFaction()
	local username = getPlayerName(client)
	local safename = mysql:escape_string(username)
	local theTeam = getPlayerTeam(client)
	local theTeamName = getTeamName(theTeam)
	
	if mysql:query_free("UPDATE characters SET faction_id='-1', faction_leader='0', dutyskin = -1, duty = 0, faction_perks='{}' WHERE charactername='" .. safename .. "'") then
		outputChatBox("Kiléptél a '" .. theTeamName .. "'-tól/től.", client)
		
		local newTeam = getTeamFromName("Citizen")
		setPlayerTeam(client, newTeam)
		exports['anticheat-system']:changeProtectedElementDataEx(client, "faction", -1, false)
		exports['anticheat-system']:changeProtectedElementDataEx(client, "factionrank", 1, false)
		exports['anticheat-system']:changeProtectedElementDataEx(client, "factionleader", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(client, "factionPackages", {}, false)
		--triggerClientEvent(client, "updateFactionInfo", client, -1, 1)
		exports['anticheat-system']:changeProtectedElementDataEx(client, "dutyskin", -1, false)
		triggerEvent("duty:offduty", client)
		
		-- Send message to everyone in the faction
		if theTeam ~= newTeam then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				if (v~=thePlayer) then
					outputChatBox(username .. " kilépett a '" .. theTeamName .. "'-tól/től.", v)
				end
			end
		end
	else
		outputChatBox("Nem tudsz kilépni a frakcióból, keress fel egy admint.", client, 255, 0, 0)
	end
end
addEvent("cguiQuitFaction", true )
addEventHandler("cguiQuitFaction", getRootElement(), callbackQuitFaction)

function callbackInvitePlayer(invitedPlayer)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Nincs engedélyezve.", client)
		return
	end
	
	
	local invitedPlayerNick = getPlayerName(invitedPlayer)
	local safename = mysql:escape_string(invitedPlayerNick)
	
	local targetTeam = getPlayerTeam(invitedPlayer)
	if (targetTeam~=nil) and (getTeamName(targetTeam)~="Citizen") then
		outputChatBox("A játékos már a frakció tagja.", client, 255, 0, 0)
		return
	end
	
	if mysql:query_free("UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1, dutyskin = -1 WHERE charactername='" .. safename .. "'") then
		local theTeam = getPlayerTeam(client)
		local theTeamName = getTeamName(theTeam)
		
		local targetTeam = getPlayerTeam(invitedPlayer)
		if (targetTeam~=nil) and (getTeamName(targetTeam)~="Citizen") then
			outputChatBox("A játékos már a frakció tagja.", client, 255, 0, 0)
		else
			setPlayerTeam(invitedPlayer, theTeam)
			exports['anticheat-system']:changeProtectedElementDataEx(invitedPlayer, "faction", factionID, false)
			outputChatBox(invitedPlayerNick .. " már a '" .. tostring(theTeamName) .. "' tagja.", client, 0, 255, 0)
							
			if	(invitedPlayer) then
				triggerEvent("onPlayerJoinFaction", invitedPlayer, theTeam)
				exports['anticheat-system']:changeProtectedElementDataEx(invitedPlayer, "factionrank", 1, false)
				--triggerClientEvent(invitedPlayer, "updateFactionInfo", invitedPlayer, factionID, 1)
				exports['anticheat-system']:changeProtectedElementDataEx(invitedPlayer, "dutyskin", -1, false)
				outputChatBox("Be lettél véve a '" .. tostring(theTeamName) .. " nevű frakcióhoz.", invitedPlayer, 255, 194, 14)
			end
		end
	else
		outputChatBox("A játékos már a frakció tagja.", client, 255, 0, 0)
	end
end
addEvent("cguiInvitePlayer", true )
addEventHandler("cguiInvitePlayer", getRootElement(), callbackInvitePlayer)

function hideFactionMenu()
	exports['anticheat-system']:changeProtectedElementDataEx(client, "factionMenu", 0, false)
end
addEvent("factionmenu:hide", true)
addEventHandler("factionmenu:hide", getRootElement(), hideFactionMenu)