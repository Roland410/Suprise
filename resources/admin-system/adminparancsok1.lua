mysql = exports.mysql


local teleportLocations = {
	-- 			x					y					z			int dim	rot
	ls = { 		1520.0029296875, 	-1701.2425537109, 	13.546875, 	0, 	0,	275	},
	sf = { 		-1689.0689697266, 	-536.7919921875, 	14.254997, 	0, 	0,	252	},
	lv = { 		1691.6801757813, 	1449.1293945313, 	10.765375,	0, 	0,	268	},
	pc = { 		2253.66796875, 		-85.0478515625, 	28.086093,	0, 	0,	180	},
	bank = { 	593.32421875, 		-1245.466796875, 	18.083688,	0, 	0,	198	},
	cityhall = {1484.369140625, 	-1763.861328125, 	18.795755,	0, 	0,	180	},
	igs = {		1970.248046875, 	-1778.4609375, 		13.546875,	0, 	0,	90	},
	lstr = {	2669.3759765625, 	-2511.7216796875, 	13.664062,	0, 	0,	180	},
	ash = {		1212.8564453125, 	-1327.5771484375, 	13.567770,	0, 	0,	90	},
	spd = {     645.5244140625, 	-1459.12109375, 	14.449489,  0,  0,  90 },
	crusher = { 2223.904296875, 	-1994.6875, 		13.546875,  0,  0,  65 },
	dmv = {  	1091.30859375, 		-1795.8984375,		13.610649,  0,  0,  65 },
	
}


function teleportToPresetPoint(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (target) then
			outputChatBox("Parancs:/" .. commandName .. " [place]", thePlayer, 255, 194, 14)
		else
			local target = string.lower(tostring(target))
			
			if (teleportLocations[target] ~= nil) then
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setVehicleTurnVelocity(veh, 0, 0, 0)
					setElementPosition(veh, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
					setVehicleRotation(veh, 0, 0, teleportLocations[target][6])
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					
					setElementDimension(veh, teleportLocations[target][5])
					setElementInterior(veh, teleportLocations[target][4])

					setElementDimension(thePlayer, teleportLocations[target][5])
					setElementInterior(thePlayer, teleportLocations[target][4])
					setCameraInterior(thePlayer, teleportLocations[target][4])
				else
					detachElements(thePlayer)
					setElementPosition(thePlayer, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
					setPedRotation(thePlayer, teleportLocations[target][6])
					setElementDimension(thePlayer, teleportLocations[target][5])
					setCameraInterior(thePlayer, teleportLocations[target][4])
					setElementInterior(thePlayer, teleportLocations[target][4])
				end
			else
				outputChatBox("Invalid Place Entered!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotoplace", teleportToPresetPoint, false, false)

------------- [gotoMark]
addEvent( "gotoMark", true )
addEventHandler( "gotoMark", getRootElement( ),
	function( x, y, z, interior, dimension, name )
		if type( x ) == "number" and type( y ) == "number" and type( z ) == "number" and type( interior ) == "number" and type( dimension ) == "number" then
			if getElementData ( client, "loggedin" ) == 1 and ( exports.global:isPlayerAdmin(client) or exports.global:isPlayerGameMaster(client) ) then
				local vehicle = nil
				local seat = nil
			
				if(isPedInVehicle ( client )) then
					 vehicle =  getPedOccupiedVehicle ( client )
					seat = getPedOccupiedVehicleSeat ( client )
				end
				detachElements(client)
				
				if(vehicle and (seat ~= 0)) then
					removePedFromVehicle (client )
					exports['anticheat-system']:changeProtectedElementDataEx(client, "realinvehicle", 0, false)
					setElementPosition(client, x, y, z)
					setElementInterior(client, interior)
					setElementDimension(client, dimension)
				elseif(vehicle and seat == 0) then
					removePedFromVehicle (client )
					exports['anticheat-system']:changeProtectedElementDataEx(client, "realinvehicle", 0, false)
					setElementPosition(vehicle, x, y, z)
					setElementInterior(vehicle, interior)
					setElementDimension(vehicle, dimension)
					warpPedIntoVehicle ( client, vehicle, 0)
				else
					setElementPosition(client, x, y, z)
					setElementInterior(client, interior)
					setElementDimension(client, dimension)
				end
				
				outputChatBox( "Teleported to Mark" .. ( name and " '" .. name .. "'" or "" ) .. ".", client, 0, 255, 0 )
			end
		end
	end
)




----1 es admin parancsai

-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID] [Élet]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if tonumber( health ) < getElementHealth( targetPlayer ) and getElementData( thePlayer, "adminlevel" ) < getElementData( targetPlayer, "adminlevel" ) then
					outputChatBox("Nah.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Hibás élet érték.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Kedves" .. targetPlayerName .. "! Az HP-d mostantól: " .. health, thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETHP "..health)
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)


-- BAN
function banAPlayer(thePlayer, commandName, targetPlayer, hours, ...)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (targetPlayer) or not (hours) or (tonumber(hours)<0) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Játékosnév/ID] [Idő(Órában), 0 = Örök] [Oka]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			hours = tonumber(hours)
			
			if not (targetPlayer) then
			elseif (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower <= thePlayerPower) then -- Check the admin isn't banning someone higher rank them him
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local accountID = getElementData(targetPlayer, "account:id")
					
					local seconds = ((hours*60)*60)
					local rhours = hours
					-- text value
					if (hours==0) then
						hours = "Örökre"
					else
						hours = hours .. " órára"
					end
					
					reason = reason .. " (" .. hours .. ")"
					
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',2,' .. mysql:escape_string(rhours) .. ',"' .. mysql:escape_string(reason) .. '")' )
					
					local showingPlayer = nil
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						outputChatBox("[BAN] " .. adminTitle .. " " .. playerName .. " kibanolta " .. targetPlayerName .. "-t a szerverről! (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("[BAN] Oka: " .. reason .. ".", getRootElement(), 255, 0, 51)
						showingPlayer = thePlayer
						
						local ban = addBan(nil, nil, getPlayerSerial(targetPlayer), thePlayer, reason, seconds)
						--local ban = banPlayer(targetPlayer, false, false, true, thePlayer, reason, seconds)
						
						if (seconds == 0) then
							mysql:query_free("UPDATE accounts SET banned='1', banned_reason='" .. mysql:escape_string(reason) .. "', banned_by='" .. mysql:escape_string(playerName) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
						end
					elseif (hiddenAdmin==1) then
						outputChatBox("[BAN] Rejtett Admin kibanolta " .. targetPlayerName .. "-t a szerverről! (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("[BAN] Oka: " .. reason, getRootElement(), 255, 0, 51)
						showingPlayer = getRootElement()
						
						local ban = addBan(nil, nil, getPlayerSerial(targetPlayer), thePlayer, reason, seconds)
						--local ban = banPlayer(targetPlayer, false, false, true, getRootElement(), reason, seconds)
						
						if (seconds == 0) then
							mysql:query_free("UPDATE accounts SET banned='1', banned_reason='" .. mysql:escape_string(reason) .. "', banned_by='" .. mysql:escape_string(playerName) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
						end
					end
					
					local serial = getPlayerSerial(targetPlayer)
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == serial then
							kickPlayer(value, showingPlayer, reason)
						end
					end
				else
					outputChatBox("Ő egy magasabb szintű admin, ezért nem tudod banolni!", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " megpróbált kibanolni téged mester!", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pban", banAPlayer, false, false)



function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("Parancs /" .. commandName .. " [Játékos neve/id] [Oka]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower <= thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					--[[outputDebugString("---------------")
					outputDebugString(getPlayerName(targetPlayer))
					outputDebugString(tostring(getElementData(targetPlayer, "account:id")))
					outputDebugString(getPlayerName(thePlayer))
					outputDebugString(tostring(getElementData(thePlayer, "account:id")))
					outputDebugString(tostring(hiddenAdmin))
					outputDebugString(reason)]]
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',1,0,"' .. mysql:escape_string(reason) .. '")' )
					
					if (hiddenAdmin==0) then
						if commandName ~= "skick" then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							outputChatBox("[KICK] " .. adminTitle .. " " .. playerName .. " kirúgta " .. targetPlayerName .. "-t a szerverről!", getRootElement(), 255, 0, 51)
							outputChatBox("[KICK] Oka: " .. reason .. ".", getRootElement(), 255, 0, 51)
						end
						kickPlayer(targetPlayer, thePlayer, reason)
					else
						if commandName ~= "skick" then
							outputChatBox("[KICK] Rejtett admin kirúgta " .. targetPlayerName .. "-t a szerverről!", getRootElement(), 255, 0, 51)
							outputChatBox("[KICK] Oka: " .. reason, getRootElement(), 255, 0, 51)
						end
						kickPlayer(targetPlayer, getRootElement(), reason)
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "PKICK "..reason)
				else
					outputChatBox(" Ez a játékos magasabb szintű admin, mint te.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " Nagyobb admint akarsz kirugni?:D", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)
addCommandHandler("skick", kickAPlayer, false, false)


function getPlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerFullGameMaster(thePlayer)) then
	
		if not (target) then
			outputChatBox("Parancs:/" .. commandName .. " /gethere [Játékos neve/id]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online!", thePlayer, 255, 0 , 0)
				else
					detachElements(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local r = getPedRotation(thePlayer)
					setCameraInterior(targetPlayer, interior)
					
					-- Maths calculations to stop the target being stuck in the player
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
					
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
						
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					outputChatBox("Magadhoz teleportáltad " .. targetPlayerName .. "-t!", thePlayer,250,0,0)
					if exports.global:isPlayerFullGameMaster(thePlayer) then
						outputChatBox(" Gamemaster " .. username .. "Magához teleportált ", targetPlayer)
					else
						outputChatBox(username .. " magához teleportált téged!", targetPlayer,0,250,0)
					end
				end
			end
		end
	end
end
addCommandHandler("gethere", getPlayer, false, false)


-- /SLAP
function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("Nem adhatsz neki pacsit mert magasabb rangu admin:D", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)
					
					if (isPedInVehicle(targetPlayer)) then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)
					
					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. "Pacsit adott neki" .. targetPlayerName .. ".")
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)



-----------------------------------[UNFREEZE]----------------------------------
function unfreezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerFullAdmin(thePlayer) or exports.global:isPlayerFullGameMaster(thePlayer)) then
		if not (target) then
			outputChatBox("Parancs /" .. commandName .. " /unfreeze [Játékos neve]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				if exports.global:isPlayerGameMaster(thePlayer) then
					textStr = "gamemaster"
					adminTitle = exports.global:getPlayerGMTitle(thePlayer)
				end
			
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					if (isElement(targetPlayer)) then
						outputChatBox(" Felolvasztott egy admin ".. textStr .."", targetPlayer)
					end
					
					if (isElement(thePlayer)) then
						outputChatBox(" Felolvasztottad" ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", false, false)
					outputChatBox(" Felolvasztott "  .. textStr ..".", targetPlayer)
					outputChatBox(" Felolvasztottad" ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("Figyelem:" .. tostring(adminTitle) .. " " .. username .. "Felolvasztotta" .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)
-----------------------------------[FREEZE]----------------------------------
function freezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerFullAdmin(thePlayer) or exports.global:isPlayerFullGameMaster(thePlayer)) then
		if not (target) then
			outputChatBox("Parancs /" .. commandName .. " [Játékos neve]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				if exports.global:isPlayerGameMaster(thePlayer) then
					textStr = "gamemaster"
					adminTitle = exports.global:getPlayerGMTitle(thePlayer)
				end
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" Lefagyasztott egy admin".. textStr .."", targetPlayer)
					outputChatBox(" Lefagyasztottad " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end
				
				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " " .. username .. " Fagyasztootta" .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)




----------------------[JAIL]--------------------
