
-- // ADMIN COMMANDS
function createFaction(thePlayer, commandName, factionType, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("Használat: /" .. commandName .. " [Frakció típus 0=Banda, 1=Maffia, 2=Rendvédelem, 3=Állam, 4=Egészségügy, 5=Egyéb, 6=Hírközlés][Frakció név]", thePlayer, 255, 194, 14)
		else
			factionName = table.concat({...}, " ")
			factionType = tonumber(factionType)
			
			local theTeam = createTeam(tostring(factionName))
			if theTeam then
				if mysql:query_free("INSERT INTO factions SET name='" .. mysql:escape_string(factionName) .. "', bankbalance='0', type='" .. mysql:escape_string(factionType) .. "'") then
					local id = mysql:insert_id()
					exports.pool:allocateElement(theTeam, id)
					
					mysql:query_free("UPDATE factions SET rank_1='Dinamikus Rang #1', rank_2='Dinamikus Rang #2', rank_3='Dinamikus Rang #3', rank_4='Dinamikus Rang #4', rank_5='Dinamikus Rang #5', rank_6='Dinamikus Rang #6', rank_7='Dinamikus Rang #7', rank_8='Dinamikus Rang #8', rank_9='Dinamikus Rang #9', rank_10='Dinamikus Rang #10', rank_11='Dinamikus Rang #11', rank_12='Dinamikus Rang #12', rank_13='Dinamikus Rang #13', rank_14='Dinamikus Rang #14', rank_15='Dinamikus Rang #15', rank_16='Dinamikus Rang #16', rank_17='Dinamikus Rang #17', rank_18='Dinamikus Rang #18', rank_19='Dinamikus Rang #19', rank_20='Dinamikus Rang #20',  motd='Üdvözöllek a frakcióban.', note = '' WHERE id='" .. id .. "'")
					outputChatBox(factionName .. " frakció elkészítve ID #" .. id .. ".", thePlayer, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "type", tonumber(factionType))
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "id", tonumber(id))
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "money", 0)
					
					local factionRanks = {}
					local factionWages = {}
					for i = 1, 20 do
						factionRanks[i] = "Dinamikus Rang #" .. i
						factionWages[i] = 100
					end
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "ranks", factionRanks, false)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "wages", factionWages, false)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "motd", "Üdvözöllek a frakcióban.", false)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "note", "", false)
					exports.logs:dbLog(thePlayer, 4, theTeam, "MAKE FACTION")
				else
					destroyElement(theTeam)
					outputChatBox("Nem lehet létrehozni.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Frakció '" .. tostring(factionName) .. "' már létezik.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("makefaction", createFaction, false, false)

function adminRenameFaction(thePlayer, commandName, factionID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID) or not (...)  then
			outputChatBox("HAsználat: /" .. commandName .. " [Frakció ID] [Frakció ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				if (theTeam) then
					local factionName = table.concat({...}, " ")
					mysql:query_free("UPDATE factions SET name='" .. mysql:escape_string(factionName) .. "' WHERE id='" .. factionID .. "'")
					
					setTeamName(theTeam, factionName)
					
					outputChatBox("Frakció #" .. factionID .. " átnevezve " .. factionName .. "-ra/re.", thePlayer, 0, 255, 0)
				else
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("renamefaction", adminRenameFaction, false, false)

function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID) then
			outputChatBox("Használat: /" .. commandName .. " [Név részlet/ID] [Frakció ID (-1 a civil)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam and factionID ~= -1 then
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if mysql:query_free("UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1, duty = 0, dutyskin = -1 WHERE id=" .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					if factionID > 0 then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "faction", factionID, false)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, false)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dutyskin", -1, false)
						triggerEvent("duty:offduty", targetPlayer)
						
						outputChatBox(targetPlayerNick .. " mostantól a '" .. getTeamName(theTeam) .. "' frakció tagja (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
						outputChatBox("Egy admin átrakott a '" .. getTeamName(theTeam) .. " frakcióba.", targetPlayer, 255, 194, 14)
						
						exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION")
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "faction", -1, false)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, false)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, -1, 1)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dutyskin", -1, false)
						if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
							takeAllWeapons(targetPlayer)
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "duty", 0, false)
						end
						
						outputChatBox(targetPlayerNick .. " elvetted a frakció tagságát.", thePlayer, 0, 255, 0)
						outputChatBox("El lettél távolítva a frakciódból.", targetPlayer, 255, 0, 0)
						
						exports.logs:dbLog(thePlayer, 4, { targetPlayer }, "REMOVE FROM FACTION")
					end
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID)  then
			outputChatBox("Használat: /" .. commandName .. " [Név Részlet] [Frakció ID]", thePlayer, 255, 194, 14)
		elseif factionID > 0 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam then
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if mysql:query_free("UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(factionID) .. ", faction_rank = 1, dutyskin = -1, duty = 0 WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "faction", factionID, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionleader", 1, false)
					--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dutyskin", -1, false)
					triggerEvent("duty:offduty", targetPlayer)
					
					outputChatBox(targetPlayerNick .. " mostantól a '" .. getTeamName(theTeam) .. "' frakció leadere (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
					triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
					outputChatBox("Egy admin kinevezett a '" .. getTeamName(theTeam) .. " frakció leaderévé.", targetPlayer, 255, 194, 14)
					
					exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION LEADER")
				else
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)
addCommandHandler("makeleader", adminSetFactionLeader, false, false)

function adminSetFactionRank(thePlayer, commandName, partialNick, factionRank)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		factionRank = math.ceil(tonumber(factionRank) or -1)
		if not (partialNick) or not (factionRank)  then
			outputChatBox("Használat: /" .. commandName .. " [Név Részlet] [Frakció rang, 1-20]", thePlayer, 255, 194, 14)
		elseif factionRank >= 1 and factionRank <= 20 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = getPlayerTeam(targetPlayer)
				if not theTeam or getTeamName( theTeam ) == "Citizen" then
					outputChatBox("A játékos nincs frakcióban.", thePlayer, 255, 0, 0)
					return
				end
				
				if mysql:query_free("UPDATE characters SET faction_rank = " .. factionRank .. " WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", factionRank, false)
					
					outputChatBox(targetPlayerNick .. " mostantól " .. factionRank .. "-as/es rangú a frakciójában.", thePlayer, 0, 255, 0)
					
					exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION RANK " .. factionRank)
				else
					outputChatBox("Error #125151 - Jelentsd fórumon.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Hibás rang - 1-20-ig lehetséges", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler("setfactionrank", adminSetFactionRank, false, false)

function adminDeleteFaction(thePlayer, commandName, factionID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (factionID)  then
			outputChatBox("Használat: /" .. commandName .. " [Frakció ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				
				if (theTeam) then
					if factionID == 57 then
						outputChatBox("So you did it! HA! Logged. Now stop deleting factions needed for the script. -Mount", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, theTeam, "DELETE FACTION: BANKFACTION")
					else
						mysql:query_free("DELETE FROM factions WHERE id='" .. factionID .. "'")
						
						outputChatBox("Frakció #" .. factionID .. " törölve.", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, theTeam, "DELETE FACTION")
						local civTeam = getTeamFromName("Citizen")
						for key, value in pairs( getPlayersInTeam( theTeam ) ) do
							setPlayerTeam( value, civTeam )
							exports['anticheat-system']:changeProtectedElementDataEx( value, "faction", -1, false )
							--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, -1, 1)
						end
						destroyElement( theTeam )
					end
				else
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Hibás frakció ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delfaction", adminDeleteFaction, false, false)

function adminShowFactions(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local result = mysql:query("SELECT id, name, type, (SELECT COUNT(*) FROM characters c WHERE c.faction_id = f.id) AS members FROM factions f ORDER BY id ASC")
		if result then
			local factions = { }
			
			while true do
				local row = mysql:fetch_assoc(result)
				if not row then break end
				
				table.insert( factions, { row.id, row.name, row.type, ( getTeamFromName( row.name ) and #getPlayersInTeam( getTeamFromName( row.name ) ) or "?" ) .. " / " .. row.members } )
			end
			
			mysql:free_result(result)
			triggerClientEvent(thePlayer, "showFactionList", getRootElement(), factions)
		else
			outputChatBox("Error 300001 - Jelentsd fórumon.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("showfactions", adminShowFactions, false, false)
addCommandHandler("frakciók", adminShowFactions, false, false)

function adminShowFactionOnlinePlayers(thePlayer, commandName, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID)  then
			outputChatBox("Használat: /" .. commandName .. " [Frakció ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				local theTeamName = getTeamName(theTeam)
				local teamPlayers = getPlayersInTeam(theTeam)
				
				if #teamPlayers == 0 then
					outputChatBox("Nincsen online játékos a '".. theTeamName .."'-ban/ben ", thePlayer, 255, 194, 14)
				else
					local teamRanks = getElementData(theTeam, "ranks")
					outputChatBox("Online játékosok a  '".. theTeamName .."'-ban/ben :", thePlayer, 255, 194, 14)
					for k, teamPlayer in ipairs(teamPlayers) do
						local leader = ""
						local playerRank = teamRanks [ getElementData(teamPlayer, "factionrank") ]
						if (getElementData(teamPlayer, "factionleader") == 1) then
							leader = "LEADER "
						end
						outputChatBox("  "..leader.." ".. getPlayerName(teamPlayer) .." - "..playerRank, thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("A frakció nem található.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("showfactionplayers", adminShowFactionOnlinePlayers, false, false)

function callbackAdminPlayersFaction(teamID)
	adminShowFactionOnlinePlayers(client, "showfactionplayers", teamID)
end
addEvent("faction:admin:showplayers", true )
addEventHandler("faction:admin:showplayers", getRootElement(), callbackAdminPlayersFaction)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("Használat: /" .. commandName .. " [Frakció ID] [Pénz]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					exports.global:setMoney(theTeam, amount)
					outputChatBox("Átállítottad a '" .. getTeamName(theTeam) .. "'  frakció pénzét " .. amount .. " Ft-ra.", thePlayer, 255, 194, 14)
				else
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Hibás frakció ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)


-----

function loadWelfare( )
	local result = mysql:query_fetch_assoc( "SELECT value FROM settings WHERE name = 'welfare'" )
	if result then
		if not result.value then
			mysql:query_free( "INSERT INTO settings (name, value) VALUES ('welfare', " .. unemployedPay .. ")" )
		else
			unemployedPay = tonumber( result.value ) or 150
		end
	end
end
addEventHandler( "onResourceStart", resourceRoot, loadWelfare )

function getTax(thePlayer)
	loadWelfare( )
	outputChatBox( "Segély: Ft" .. exports.global:formatMoney(unemployedPay), thePlayer, 255, 194, 14 )
	outputChatBox( "Adó: " .. ( exports.global:getTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
	outputChatBox( "Jövedelemadó: " .. ( exports.global:getIncomeTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
end
addCommandHandler("gettax", getTax, false, false)

function setFactionBudget(thePlayer, commandName, factionID, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Onkormanyzat") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not factionID or not amount or amount < 0 then
			outputChatBox("Használat: /" .. commandName .. " [Frakció ID] [Pénz]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					if getElementData(theTeam, "type") >= 2 and getElementData(theTeam, "type") <= 6 then
						if exports.global:takeMoney(getPlayerTeam(thePlayer), amount) then
							exports.global:giveMoney(theTeam, amount)
							outputChatBox("Adományoztál " .. exports.global:formatMoney(amount) .. " FT-ot a '" .. getTeamName(theTeam) .. "' költségvetéséhez (Összesen: " .. exports.global:getMoney(theTeam) .. ").", thePlayer, 255, 194, 14)
							mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(getPlayerTeam(thePlayer), "id") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 8)" )
						else
							outputChatBox("Ezt nem tudod finanszírozni.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("Ennek a frakciónak nem tudsz adományozni.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Hibás frakció ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Hibás frakció ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("adomány", setFactionBudget, false, false)


function setTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("NAV") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 30 then
			outputChatBox("Használat: /" .. commandName .. " [0-30%]", thePlayer, 255, 194, 14)
		else
			exports.global:setTaxAmount(amount)
			outputChatBox("================== [ Nemzeti Adóhivatal Felhívás ]==================", getRootElement(), 255, 255, 0)
            outputChatBox("Az új adó " .. amount .. "%", getRootElement(), 0, 255, 0)
			outputChatBox("================== [ Nemzeti Adóhivatal Felhívás ]==================", getRootElement(), 255, 255, 0)
		end
	end
end
addCommandHandler("settax", setTax, false, false)

function setIncomeTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Onkormanyzat") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 25 then
			outputChatBox("Használat: /" .. commandName .. " [0-25%]", thePlayer, 255, 194, 14)
		else
			
			exports.global:setIncomeTaxAmount(amount)
			outputChatBox("================== [ Állami Felhívás ]==================", getRootElement(), 255, 255, 0)
            outputChatBox("Az új jövedelemadó " .. amount .. "%", getRootElement(), 0, 255, 0)
			outputChatBox("================== [ Állami Felhívás ]==================", getRootElement(), 255, 255, 0)
		end
	end
end
addCommandHandler("jadó", setIncomeTax, false, false)

function setWelfare(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Onkormanyzat") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount <= 0 then
			outputChatBox("Használat: /" .. commandName .. " [Pénz]", thePlayer, 255, 194, 14)
		elseif mysql:query_free( "UPDATE settings SET value = " .. unemployedPay .. " WHERE name = 'welfare'" ) then
			unemployedPay = amount
			outputChatBox("Az új segélymennyiség " .. exports.global:formatMoney(unemployedPay) .. " Ft.", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 129314 - Jelentsd fórumon.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("segély", setWelfare, false, false)
