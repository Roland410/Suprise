mysql = exports.mysql


function givevPoint(thePlayer, commandName, targetPlayer, vPoints, ...)
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		if (not targetPlayer or not vPoints or not (...)) then
			outputChatBox("Parancs: /" .. commandName .. " [játékos] [Pont] [oka]", thePlayer, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if (tplayer) then
				local loggedIn = getElementData(tplayer, "loggedin")
				if loggedIn == 1 then
					if (tonumber(vPoints) < 5000) then
						local reasonStr = table.concat({...}, " ")
						local accountID = getElementData(tplayer, "account:id")
						triggerClientEvent(tplayer, "onPlayerGetAchievement", thePlayer, "Prémiumpont!", "Prémiumpont!", "Megkaptad a prémium csomagod nyomd meg az f7 gombot! \n Csomag:" .. reasonStr, vPoints)
						mysql:query_free("UPDATE `accounts` SET `credits`=`credits`+".. tostring(vPoints) .." WHERE `id`=".. tostring(accountID)  .."")
						exports.logs:dbLog(thePlayer, 26, tplayer, "GIVEVPOINTS "..tostring(vPoints).." "..reasonStr)
						outputChatBox(""..targetPlayerName.." -nak/nek adtál "..vPoints.." Prémium csomagot! Csomag tipusa: ".. reasonStr, thePlayer,0, 255, 0)
						
						mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(tplayer)) .. '",' .. mysql:escape_string(tostring(getElementData(tplayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,6,'.. vPoints ..',"' .. mysql:escape_string(vPoints .. " vPoints for: " .. reasonStr) .. '")' )
					else
						outputChatBox("Max 3 pont/nap", thePlayer)
					end
				else
					outputChatBox("Játékos nem online.", thePlayer)
				end
			else
				outputChatBox("", thePlayer)
			end
		end
	end
end
addCommandHandler("ppont", givevPoint)



function vehicleLimit(admin, command, player, limit)
	if exports.global:isPlayerTulajAdmin(admin) then
		if (not player and not limit) then
			outputChatBox("Parancs /" .. command .. " [Játákos] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				local query = mysql:query_fetch_assoc("SELECT maxvehicles FROM characters WHERE id = " .. mysql:escape_string(getElementData(tplayer, "dbid")))
				if (query) then
					local oldvl = query["maxvehicles"]
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							mysql:query_free("UPDATE characters SET maxvehicles = " .. mysql:escape_string(newl) .. " WHERE id = " .. mysql:escape_string(getElementData(tplayer, "dbid")))

							exports['anticheat-system']:changeProtectedElementDataEx(tplayer, "maxvehicles", newl, false)
							
							outputChatBox("Beálitottad" .. targetPlayerName:gsub("_", " ") .. "Jármű limitet neki " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " beálitotta a limitet " .. newl .. ".", tplayer, 255, 194, 14)
							
							exports.logs:dbLog(thePlayer, 4, tplayer, "SETVEHLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("Nem lehet beállítani szint alatt 0", admin, 255, 194, 14)
						end
					end
				end
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	end
end
addCommandHandler("setvehlimit", vehicleLimit)


function makePlayerAdmin(thePlayer, commandName, who, rank)
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("Parancs /" .. commandName .. " [Játékos neve/ID] [Rang]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				rank = math.floor(tonumber(rank))
				if exports.global:isPlayerHeadAdmin(thePlayer) then
				elseif exports.global:isPlayerGMTeamLeader(thePlayer) then
					-- do restrict GM team leader to set GM ranks only
					if exports.global:isPlayerAdmin(targetPlayer) then
						outputChatBox("Nem lehet beállítani a játékos rangját.", thePlayer, 255, 0, 0)
						return
					else
						if rank > 0 or rank < -4 then
							outputChatBox("Nem lehet beállítani ezt a rangot.", thePlayer, 255, 0, 0)
							return
						end
					end
				else
					return
				end
				
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")
				
				local query = mysql:query_free("UPDATE accounts SET admin='" .. mysql:escape_string(rank) .. "', hiddenadmin='0' WHERE id='" .. mysql:escape_string(accountID) .. "'")
				if (rank > 0) or (rank == -999999999) then
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 1, false)
				else
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 0, false)
				end
				mysql:query_free("UPDATE accounts SET adminduty=" .. mysql:escape_string(getElementData(targetPlayer, "adminduty")) .. " WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "account:id")) )
				
				
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				if (rank < 0) then
					local gmrank = -rank
					outputChatBox("You set " .. targetPlayerName .. "'s GM rank to " .. tostring(gmrank) .. ".", thePlayer, 0, 255, 0)
					outputChatBox(adminTitle .. " " .. username .. " set your GM rank to " .. gmrank .. ".", targetPlayer, 255, 194, 14)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmlevel", gmrank, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmduty", true, true)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminlevel", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 0, false)
				else
					outputChatBox(adminTitle .. " " .. username .. " set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
					outputChatBox("You set " .. targetPlayerName .. "'s Admin rank to " .. tostring(rank) .. ".", thePlayer, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminlevel", rank, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 1, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmlevel", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmduty", false, true)
				end
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "MAKEADMIN " .. rank)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				-- Fix for scoreboard & nametags
				if (hiddenAdmin==0) then
					exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " " .. username .. " set " .. targetPlayerName .. "'s admin level to " .. rank .. ".")
				end
				
				exports.global:updateNametagColor(targetPlayer)
			end
		end
	end
end
addCommandHandler("setalevel", makePlayerAdmin, false, false)


function deleteVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("Parancs: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", dbid)
			if theVehicle then
				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then -- TEMP vehicle
					destroyElement(theVehicle)
				else
					if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
						mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
						call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
						call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
						exports.logs:dbLog(thePlayer, 6, { theVehicle }, "DELVEH" )
						destroyElement(theVehicle)
						--exports.logs:logMessage("[DELVEH] " .. getPlayerName( thePlayer ) .. " deleted vehicle #" .. dbid, 9)
					else
						outputChatBox("You do not have permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
						return
					end
				end
				outputChatBox("Vehicle deleted.", thePlayer)
			else
				outputChatBox("Nem találtam ezt a jármű ID-t!", thePlayer, 0, 0, 240)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)

-- DELTHISVEH

function deleteThisVehicle(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local dbid = getElementData(veh, "dbid")
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		if dbid < 0 or exports.global:isPlayerSuperAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			else
				if dbid > 0 then
					mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
					call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
					call( getResourceFromName( "item-system" ), "clearItems", veh )
					exports.logs:logMessage("[DELVEH] " .. getPlayerName( thePlayer ) .. " deleted vehicle #" .. dbid, 9)
					exports.logs:dbLog(thePlayer, 6, { veh  }, "DELVEH")
				end
				destroyElement(veh)
			end
		else
			outputChatBox("You do not have the permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
			return
		end
	end
end
addCommandHandler("delthisveh", deleteThisVehicle, false, false)

function ujModel(thePlayer, theCommand, vehicleID, factionID)
	if (exports.global:isPlayerTulajAdmin(thePlayer) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (vehicleID) or not (factionID) then
			outputChatBox("Parancs: /" .. theCommand .. " [kocsiid] [fmodeil id]", thePlayer, 255, 194, 14)
		else
			
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			if theVehicle then
			
				mysql:query_free("UPDATE `vehicles` SET `model`='" .. mysql:escape_string(factionID) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
				
				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("kész.", thePlayer)
			else
				outputChatBox("Nincs ilyen kocsi.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("ujmodell", ujModel)

-- /MAKEGUN
function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerTulajAdmin(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Weapon ID] [Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local weapon = tonumber(args[1])
				local ammo = #args ~= 1 and tonumber(args[#args]) or 1
				
				if not getWeaponNameFromID(weapon) then
					outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if (weapon == 38) or (weapon == 37) or (weapon == 36) then
					outputChatBox("No.", thePlayer, 255,0,0)
					return
				end
				
				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local adminDBID = tonumber(getElementData(thePlayer, "account:character:id"))
					local playerDBID = tonumber(getElementData(targetPlayer, "account:character:id"))
					local mySerial = exports.global:createWeaponSerial( 1, adminDBID, playerDBID)
					local give, error = exports.global:giveItem(targetPlayer, 115, weapon..":"..mySerial..":"..getWeaponNameFromID(weapon))
					if give then
						outputChatBox("Player " .. targetPlayerName .. " now has a " .. getWeaponNameFromID(weapon) .. " with serial '"..mySerial.."'.", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON "..getWeaponNameFromID(weapon).." "..tostring(mySerial))
						if (hiddenAdmin==0) then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a " .. getWeaponNameFromID(weapon) .. " with serial '"..mySerial.."'")
						end
					else
						outputChatBox("Error: ".. error ..".", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)

-- /makeammo
function givePlayerGunAmmo(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerTulajAdmin(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Weapon ID] [Amount in clip] [Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local weapon = tonumber(args[1])
				local ammo =  tonumber(args[2]) or 1
				
				if not getWeaponNameFromID(weapon) then
					outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if (weapon == 38) or (weapon == 37) or (weapon == 36) then
					outputChatBox("No.", thePlayer, 255,0,0)
					return
				end
				
				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local give, error = exports.global:giveItem(targetPlayer, 116, weapon..":"..ammo..":Ammo for "..getWeaponNameFromID(weapon))
					if give then
						outputChatBox("Player " .. targetPlayerName .. " now has an ammopack for an " .. getWeaponNameFromID(weapon) .. " with '"..ammo.."' bullets.", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEBULLETS "..getWeaponNameFromID(weapon).." "..tostring(bullets))
						if (hiddenAdmin==0) then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " an " .. getWeaponNameFromID(weapon) .. " magazine with '"..ammo.."' bullets.")
						end
					else
						outputChatBox("Error: ".. error ..".", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)

-- /GIVEITEM
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerTulajAdmin(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID] [Cikk ID] [Cikk érték]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if ( itemID == 74 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.global:isPlayerScripter( thePlayer ) and not exports.global:isPlayerHeadAdmin( thePlayer) then
					-- nuthin
				elseif ( itemID == 84 ) and not exports.global:isPlayerLeadAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.global:isPlayerSuperAdmin( thePlayer ) then
				elseif (itemID == 115 or itemID == 116) then
					outputChatBox("Nem létező item", thePlayer, 255, 0, 0)
				elseif (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )
					
					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Játékos " .. targetPlayerName .. " Kaptál" .. name .. " Érékkel" .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..name.." "..tostring(itemValue))
							
						
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
						else
							outputChatBox("Nem lehet adni " .. targetPlayerName .. " nak/nek " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Hibás Cikk ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)



function setMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		local money = tonumber((money:gsub(",","")))
		if not (target) then
			outputChatBox("Parancs /" .. commandName .. " [Játékos neve] [összeg]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY "..money)
				exports.global:setMoney(targetPlayer, money)
				outputChatBox(targetPlayerName .. " Kaptál" .. exports.global:formatMoney(money) .. " Ft.", thePlayer)
				outputChatBox("Admin " .. username .. " Adott neki " .. exports.global:formatMoney(money) .. " Ft.", targetPlayer)
			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

function giveMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		local money = tonumber((money:gsub(",","")))
		if not (target) then
			outputChatBox("Parancs /" .. commandName .. " [Játékos neve] [Összeg]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEMONEY " ..money)
				exports.global:giveMoney(targetPlayer, money)
				outputChatBox("Adtál neki " .. targetPlayerName .. " Ft-ot" .. exports.global:formatMoney(money) .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " Adott neked Ft-ot" .. exports.global:formatMoney(money) .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)




function setCarHP(thePlayer, commandName, target, hp)
	if (exports.global:isPlayerTulajAdmin(thePlayer)) then
		if not (target) or not (hp) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Player Nick] [Health]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local sethp = setElementHealth(veh, tonumber(hp))
						
						if (sethp) then
							outputChatBox("You set " .. targetPlayerName .. "'s vehicle health to " .. hp .. ".", thePlayer)
							--exports.logs:logMessage("[/SETCARHP] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." set ".. targetPlayerName .. "his car to hp: " .. hp , 4)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHHP ".. hp )
						else
							outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcarhp", setCarHP, false, false)


-- /unflip
function unflipCar(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerTulajAdmin(thePlayer) or getTeamName(getPlayerTeam(thePlayer)) == "Hex Tow 'n Go") then
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




function fixAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerFoAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			fixVehicle(value)
			if (not getElementData(value, "Impounded")) then
				exports['anticheat-system']:changeProtectedElementDataEx(value, "enginebroke", 0, false)
				if armoredCars[ getElementModel( value ) ] then
					setVehicleDamageProof(value, true)
				else
				setVehicleDamageProof(value, false)
				end
			end
		end
		outputChatBox("Összes jármű megjavíta " .. username .. " által.")
		exports.logs:dbLog(thePlayer, 6, { targetPlayer }, "FIXALLVEHS")
	end
end
addCommandHandler("fixvehs", fixAllVehicles)


function setVehicleFaction(thePlayer, theCommand, vehicleID, factionID)
    if exports.global:isPlayerFoAdmin(thePlayer) then		if not (vehicleID) or not (factionID) then
			outputChatBox("Parancs: /" .. theCommand .. " [vehicleID] [factionID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			local factionElement = exports.pool:getElement("team", factionID)
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "account:character:id")
				else
					if not factionElement then
						outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
						return
					end
				end
			
				mysql:query_free("UPDATE `vehicles` SET `owner`='".. mysql:escape_string(owner) .."', `faction`='" .. mysql:escape_string(factionID) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
				
				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("Done.", thePlayer)
			else
				outputChatBox("No vehicle with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehiclefaction", setVehicleFaction)


function fixPlayerVehicle(thePlayer, commandName, target)
	if exports.global:isPlayerFoAdmin(thePlayer) then
		if not (target) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						if (getElementData(veh, "Impounded") == 0) then
							exports['anticheat-system']:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
							if armoredCars[ getElementModel( veh ) ] then
								setVehicleDamageProof(veh, true)
							else
								setVehicleDamageProof(veh, false)
							end
						end
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FIXVEH")
						outputChatBox("Megjavítottad " .. targetPlayerName .. " járművét.", thePlayer)
						outputChatBox("A járműved meg lett javítva " .. username .. " Admin által.", targetPlayer)
					else
						outputChatBox("Ez a játékos nincs járműben.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixPlayerVehicle, false, false)


function setPlayerVehicleColor(thePlayer, commandName, target, ...)
	if (exports.global:isPlayerScripterAdmin(thePlayer)) then
		if not (target) or not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Player Nick] [Colors ...]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						-- parse colors
						local colors = {...}
						local col = {}
						for i = 1, math.min( 4, #colors ) do
							local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
							if r and g and b then
								col[i] = {r=r, g=g, b=b}
							elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
								col[i] = math.floor(tonumber(colors[i]))
							else
								outputChatBox("Invalid color: " .. colors[i], thePlayer, 255, 0, 0)
								return
							end
						end
						if not col[2] then col[2] = col[1] end
						if not col[3] then col[3] = col[1] end
						if not col[4] then col[4] = col[2] end
						
						local set = false
						if type( col[1] ) == "number" then
							set = setVehicleColor(veh, col[1], col[2], col[3], col[4])
						else
							set = setVehicleColor(veh, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
						end
						
						if set then
							outputChatBox("Vehicle's color was set.", thePlayer, 0, 255, 0)
							exports['savevehicle-system']:saveVehicleMods(veh)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHICLECOLOR ".. table.concat({...}, " ") )
						else
							outputChatBox("Invalid Color ID.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)


function setVehTint(admin, command, target, status)
	if (exports.global:isPlayerScripterAdmin(admin) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (target) or not (status) then
			outputChatBox("Parancs: /" .. command .. " [player] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, target)
			
			if (targetPlayer) then
				local pv = getPedOccupiedVehicle(targetPlayer)
				if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if (stat == 1) then
						mysql:query_free("UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. mysql:escape_string(vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("setTintName", pv, player)
							end
						end
						
						exports['anticheat-system']:changeProtectedElementDataEx(pv, "tinted", true, true)

						outputChatBox("You have added tint to vehicle #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.global:isPlayerLeadAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " added tint to vehicle #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						
						exports.logs:dbLog(thePlayer, 6, {pv, targetPlayer}, "SETVEHTINT 1" )
					elseif (stat == 0) then
						mysql:query_free("UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. mysql:escape_string(vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("resetTintName", pv, player)
							end
						end
						exports['anticheat-system']:changeProtectedElementDataEx(pv, "tinted", false, true)

						outputChatBox("You have removed tint from vehicle #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.global:isPlayerLeadAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " removed tint from vehicle #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						exports.logs:dbLog(thePlayer, 4, {pv, targetPlayer}, "SETVEHTINT 0" )
					end
				else
					outputChatBox("Player not in a vehicle.", admin, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("setvehtint", setVehTint)


function setVehiclePlate(thePlayer, theCommand, vehicleID, ...)
	if (exports.global:isPlayerScripterAdmin(thePlayer) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (vehicleID) or not (...) then
			outputChatBox("Parancs: /" .. theCommand .. " [vehicleID] [Text]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			if theVehicle then
				if exports['vehicle-system']:hasVehiclePlates(theVehicle) then
					local plateText = table.concat({...}, " ")
					if (exports['vehicle-plate-system']:checkPlate(plateText)) then
						local cquery = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. mysql:escape_string(plateText).."'")
						if (tonumber(cquery["no"]) == 0) then
							local insertnplate = mysql:query_free("UPDATE vehicles SET plate='" .. mysql:escape_string(plateText) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
							local x, y, z = getElementPosition(theVehicle)
							local int = getElementInterior(theVehicle)
							local dim = getElementDimension(theVehicle)
							exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
							local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
							setElementPosition(newVehicleElement, x, y, z)
							setElementInterior(newVehicleElement, int)
							setElementDimension(newVehicleElement, dim)
							outputChatBox("Done.", thePlayer)
						else
							outputChatBox("This plate is already in use! =( umadbro?", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid plate text specified.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("This vehicle doesn't have any plates.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehicleplate", setVehiclePlate)



function setVehicleFaction(thePlayer, theCommand, vehicleID, factionID)
	if (exports.global:isPlayerScripterAdmin(thePlayer) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (vehicleID) or not (factionID) then
			outputChatBox("Parancs: /" .. theCommand .. " [vehicleID] [factionID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			local factionElement = exports.pool:getElement("team", factionID)
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "account:character:id")
				else
					if not factionElement then
						outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
						return
					end
				end
			
				mysql:query_free("UPDATE `vehicles` SET `owner`='".. mysql:escape_string(owner) .."', `faction`='" .. mysql:escape_string(factionID) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
				
				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("Done.", thePlayer)
			else
				outputChatBox("No vehicle with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehiclefaction", setVehicleFaction)



-- /UNBAN
function unbanPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerFoAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Játékosnév/IP/Serial]", thePlayer, 255, 194, 14)
		else
			local searchString = table.concat({...}, " ")
			local searchStringM =  string.gsub(searchString, " ", "_")
			local accountID = nil
			local searchCode = "UN" 
			local localBan = nil
			
			-- Try on account name or serial or ip
			if not accountID then
				local accountSearch = mysql:query_fetch_assoc("SELECT `id` FROM `accounts` WHERE `username`='" .. mysql:escape_string(tostring(searchString)) .. "' or `mtaserial`='" .. mysql:escape_string(tostring(searchString)) .. "' or `ip`='" .. mysql:escape_string(tostring(searchString)) .. "' LIMIT 1")
				if accountSearch then
					accountID = accountSearch["id"]
					searchCode = "DA"
				end
			end
			
			-- Try on character name
			if not accountID then
				
				local characterSearch = mysql:query_fetch_assoc("SELECT `account` FROM `characters` WHERE `charactername`='" .. mysql:escape_string(tostring(searchStringM)) .. "' LIMIT 1")
				if characterSearch then
					accountID = characterSearch["account"]
					searchCode = "DC"
				end
			end
			
			-- Check local
			if not accountID then
				for _, banElement in ipairs(getBans()) do
					if (getBanSerial(banElement) == searchString) then
						accountID = -1
						searchCode = "XS"
						localBan = banElement
						break
					end
					
					if (getBanIP(banElement) == searchString) then
						accountID = -1
						searchCode = "XI"
						localBan = banElement
						break
					end
					
					if (getBanNick(banElement) == searchStringM) then
						accountID = -1
						searchCode = "XN"
						localBan = banElement
						break
					end
				end
			end
			
			if not accountID then
				outputChatBox("Nincs tilalom találat '" .. searchString .. "'", thePlayer, 255, 0, 0)
				return
			end
			
			if (accountID == -1 and localBan) then
				exports.global:sendMessageToAdmins("[BanMan] "..getBanNick(localBan) .. "/"..getBanSerial(localBan).." Unbannolta " .. getPlayerName(thePlayer) .. ". (S: ".. searchCode ..")")
				removeBan( localBan )
				return
			end
			
			-- Get ban details
			local banDetails = mysql:query_fetch_assoc("SELECT `ip`, `mtaserial`, `username`, `id`, `banned` FROM `accounts` WHERE `id`='" .. mysql:escape_string(tostring(accountID)) .. "' LIMIT 1")
			if banDetails then 
			
				-- Check local
				local unbannedSomething = false
				for _, banElement in ipairs(getBans()) do
					local unban = false
					if (getBanSerial(banElement) == banDetails["mtaserial"]) then
						searchCode = searchCode .. "-XS"
						unban = true
					end
					
					if (getBanIP(banElement) == banDetails["ip"]) then
						searchCode = searchCode .. "-IS"
						unban = true
					end
					
					if unban then
						removeBan(banElement)		
						unbannedSomething = true
					end
				end
				
				if not (unbannedSomething) and not (banDetails["banned"] == 1) then
					outputChatBox("Nincs találat'" .. searchString .. "'", thePlayer, 255, 0, 0)
				else
					exports.global:sendMessageToAdmins("[BanMan] "..banDetails["username"] .. "/"..banDetails["mtaserial"].."/".. banDetails["id"] .." Unbannolt " .. getPlayerName(thePlayer) .. ". (S: ".. searchCode ..")")
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(banDetails["username"])..'",' ..accountID .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
					mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL, banned_reason=NULL WHERE id='" .. mysql:escape_string(banDetails["id"]) .. "'")
				end
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)



--give player license
function givePlayerLicense(thePlayer, commandName, targetPlayerName, licenseType)
	if exports.global:isPlayerFoAdmin(thePlayer) then
		if not targetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("Parancs: /" .. commandName .. " [Játékosnév/id] [Tipus]", thePlayer, 255, 194, 14)
			outputChatBox("Tipus 1 = Autó", thePlayer, 255, 194, 14)
			outputChatBox("Tipus 2 = Fegyver", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "Autó" or "Fegyver"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 1 then
						outputChatBox(getPlayerName(thePlayer).." Már van neki"  ..licenseTypeOutput.." Engedélye.", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
							if exports.global:isPlayerSuperAdmin(thePlayer) then
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
								mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
								
								outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." Adtál neki"  ..licenseTypeOutput.." Engedélyt.", targetPlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE GUN")
								local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
								if (hiddenAdmin==0) then
									local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
									exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a weapon license.")
								else
									outputChatBox("Játékos "..targetPlayerName.." most van egy"..licenseTypeOutput.." Engedꭹ.", thePlayer, 0, 255, 0)
								end
							else
								outputChatBox("ő nem kap fegyver engedélyt", thePlayer, 255, 0, 0)
							end
						else
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE CAR")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a drivers license.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("agl", givePlayerLicense)


--take player license
function takePlayerLicense(thePlayer, commandName, dtargetPlayerName, licenseType)
	if exports.global:isPlayerFoAdmin(thePlayer) then
		if not dtargetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Nick] [Type]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Driver", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Weapon", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(nil, dtargetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "driver" or "weapon"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 0 then
						outputChatBox(getPlayerName(thePlayer).." has no "..licenseTypeOutput.." license.", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='0' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							--outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")
							
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " his ".. licenseType .." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						else
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='0' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE CAR")
							
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " his ".. licenseType .." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			else
				local resultSet = mysql:query_fetch_assoc("SELECT `id`,`car_license`,`gun_license` FROM `characters` where `charactername`='"..mysql:escape_string(dtargetPlayerName).."'")
				if resultSet then
					licenseType = licenseType == "1" and "car" or "gun"
					if (tonumber(resultSet[licenseType.."_license"]) ~= 0) then
						local resultQry = mysql:query_free("UPDATE `characters` SET `"..licenseType.."_license`=0 WHERE `charactername`='"..mysql:escape_string(dtargetPlayerName).."'")
						if (resultQry) then
							exports.logs:dbLog(thePlayer, 4, { "ch"..resultSet["id"] }, "TAKELICENSE "..licenseType)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. dtargetPlayerName .. " his ".. licenseType .." license.")
							else
								outputChatBox("Player "..dtargetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						else
							outputChatBox("Wups, atleast something went wrong there..", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("The player doesn't have this license.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("No player found.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("atakelicense", takePlayerLicense)