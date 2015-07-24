mysql = exports.mysql






-- EJECT
function ejectPlayer(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("Parancs /" .. commandName .. " [Játékos neve]", thePlayer, 255, 194, 14)
	else
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("Nincs a kocsiba senki", thePlayer, 255, 0, 0)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local seat = getPedOccupiedVehicleSeat(thePlayer)
			
			if (seat~=0) then
				outputChatBox("Nem te vagy a soför", thePlayer, 255, 0, 0)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
				
				if not (targetPlayer) then
				elseif (targetPlayer==thePlayer) then
					outputChatBox("Magadat hogy akarod kilökni?", thePlayer, 255, 0, 0)
				else
					local targetvehicle = getPedOccupiedVehicle(targetPlayer)
					
					if targetvehicle~=vehicle and not exports.global:isPlayerAdmin(thePlayer) then
						outputChatBox("Nincs a kocsiba senki", thePlayer, 255, 0, 0)
					else
						outputChatBox("Kilökted " .. targetPlayerName .. " az autobol", thePlayer, 0, 255, 0)
						removePedFromVehicle(targetPlayer)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false)


function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("Parancs /" .. commandName .. " [Játékos neve]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
		
		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("** " .. targetPlayerName .. "'s ID is " .. id .. ".", thePlayer, 255, 194, 14)
			else
				outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)


-- /CHANGENAME
function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID] [Játékos uj neve]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if newName == targetPlayerName then
					outputChatBox( "Ez már foglalt név", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					local result = mysql:query("SELECT charactername FROM characters WHERE charactername='" .. mysql:escape_string(newName) .. "' AND id != " .. mysql:escape_string(dbid))
					
					if (mysql:num_rows(result)>0) then
						outputChatBox("Ez a név már foglalt.", thePlayer, 255, 0, 0)
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
						local name = setPlayerName(targetPlayer, tostring(newName))
						
						if (name) then
							exports['cache']:clearCharacterName( dbid )
							mysql:query_free("UPDATE characters SET charactername='" .. mysql:escape_string(newName) .. "' WHERE id = " .. mysql:escape_string(dbid))
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " "  .. getPlayerName(thePlayer) .. "Átirta"  .. targetPlayerName .. "'Nevét erre: " .. newName .. ".")
							end
							outputChatBox("Régi neved:" .. targetPlayerName .. "Uj neved " .. tostring(newName) .. ".", thePlayer, 0, 255, 0)
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
							
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "CHANGENAME "..targetPlayerName.." -> "..tostring(newName))
							triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
						else
							outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
						end
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
					end
					mysql:free_result(result)
				end
			end
		end
	end
end
addCommandHandler("névváltás", asetPlayerName, false, false)



-- /TAKEITEM
function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID] [Cikk ID] [Cikk érték]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if exports.global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took that Item " .. itemID .. " from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.global:takeItem(targetPlayer, itemID, itemValue)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM "..tostring(itemID).." "..tostring(itemValue))
						
						triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)




-- /MUTE
function mutePlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Parancs: /" .. commandName .. " [Játékosnév/ ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos neve", thePlayer, 255, 0, 0)
				else
					local muted = getElementData(targetPlayer, "muted") or 0
					
					if muted == 0 then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "muted", 1, false)
						outputChatBox(targetPlayerName .. " is now muted from OOC.", thePlayer, 255, 0, 0)
						outputChatBox("Némitva voltál '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "MUTE")
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "muted", 0, false)
						outputChatBox(targetPlayerName .. " Mostantol ujra beszélhetsz", thePlayer, 0, 255, 0)
						outputChatBox("Unmutoltad '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMUTE")
					end
					mysql:query_free("UPDATE accounts SET muted=" .. mysql:escape_string(getElementData(targetPlayer, "muted")) .. " WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "account:id")) )
				end
			end
		end
	end
end
addCommandHandler("pmute", mutePlayer, false, false)

-- /DISARM
function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					for i = 115, 116 do
						while exports['item-system']:takeItem(targetPlayer, i) do
						end
					end
					outputChatBox(targetPlayerName .. " most hatástalanítják.", thePlayer, 255, 194, 14)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "DISARM")
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)


-- /thiscar
function getCarID(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	
	if (veh) then
		local dbid = getElementData(veh, "dbid")
		outputChatBox("Mostani kocsi ID: " .. dbid, thePlayer, 255, 194, 14)
	else
		outputChatBox("Nem vagy kocsiban.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("thiscar", getCarID, false, false)

function unflipCar(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerLeadAdmin(thePlayer) or getTeamName(getPlayerTeam(thePlayer)) == "Hex Tow 'n Go") then
		if not targetPlayer or not exports.global:isPlayerAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in vehicle.", thePlayer, 255, 0, 0)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				outputChatBox("Your car was unflipped!", thePlayer, 0, 255, 0)
			end
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 0, ry, rz)
						if getElementData(thePlayer, "hiddenadmin") == 1 then
							outputChatBox("Your car was unflipped by a Hidden Admin.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Your car was unflipped by " .. username .. ".", targetPlayer, 0, 255, 0)
						end
						outputChatBox("You unflipped " .. targetPlayerName:gsub("_"," ") .. "'s car.", thePlayer, 0, 255, 0)
					else
						outputChatBox(targetPlayerName:gsub("_"," ") .. " is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

-- /unlockcivcars
function unlockAllCivilianCars(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local count = 0
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			if (isElement(value)) and (getElementType(value)) then
				local id = getElementData(value, "dbid")
				
				if (id) and (id>=0) then
					local owner = getElementData(value, "owner")
					if (owner==-2) then
						setVehicleLocked(value, false)
						count = count + 1
					end
				end
			end
		end
		
		outputChatBox("Unlocked " .. count .. " civilian vehicles.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("unlockcivcars", unlockAllCivilianCars, false, false)