mysql = exports.mysql

armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
totalTempVehicles = 0
respawnTimer = nil



function szerContract( thePlayer, commandName, targetPlayerName )
	if exports.global:isPlayerFoAdmin( thePlayer ) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = mysql:query_free("UPDATE characters SET job = 5 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) .. " AND jobcontract > 0" )
					if result then
						outputChatBox( "MSzerelőnek beraktad  " .. targetPlayerName, thePlayer, 0, 255, 0 )
					else
						outputChatBox( "Nem sikerült a munka szerződés újrakötezése", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "A játékos nincs bejelentkezve.", thePlayer, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "HASZNÁLATA: /" .. commandName .. " [játékos]", thePlayer, 255, 194, 14 )
		end
	end
end
addCommandHandler("szerelö", szerContract, false, false)






addEvent("onVehicleDelete", false)

function findVehID(thePlayer, commandName, ...)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Name]", thePlayer, 255, 194, 14)
		else
			local vehicleName = table.concat({...}, " ")
			local carID = getVehicleModelFromName(vehicleName)
			
			if (carID) then
				local fullName = getVehicleNameFromModel(carID)
				outputChatBox(fullName .. ": ID " .. carID .. ".", thePlayer)
			else
				outputChatBox("Vehicle not found.", thePlayer, 255, 0 , 0)
			end
		end
	end
end
addCommandHandler("findveh", findVehID, false, false)


function blowPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
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
						blowVehicle(veh)
						outputChatBox("You blew up " .. targetPlayerName .. "'s vehicle.", thePlayer)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "BLOWVEH" )
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("blowveh", blowPlayerVehicle, false, false)

-----------------------------[SET CAR HP]---------------------------------
function setCarHP(thePlayer, commandName, target, hp)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
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



function getPosition(thePlayer, commandName)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local rotation = getPedRotation(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		
		outputChatBox("Pozicio: " .. x .. ", " .. y .. ", " .. z, thePlayer, 255, 194, 14)
		outputChatBox("Forgatás: " .. rotation, thePlayer, 255, 194, 14)
		outputChatBox("Dimenzio: " .. dimension, thePlayer, 255, 194, 14)
		outputChatBox("Interior: " .. interior, thePlayer, 255, 194, 14)
	end
end
addCommandHandler("getpos", getPosition, false, false)



function fixAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
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


function fixPlayerVehicle(thePlayer, commandName, target)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
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

-----------------------------[FIX VEH VIS]---------------------------------
function fixPlayerVehicleVisual(thePlayer, commandName, target)
	if (exports.global:isPlayerHeadAdmin(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local health = getElementHealth(veh)
						fixVehicle(veh)
						setElementHealth(veh, health)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FIXVEHVIS" )
						outputChatBox("You repaired " .. targetPlayerName .. "'s vehicle visually.", thePlayer)
						outputChatBox("Your vehicle was visually repaired by admin " .. username .. ".", targetPlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixvehvis", fixPlayerVehicleVisual, false, false)



function warpPedIntoVehicle2(player, car, ...)
	local dimension = getElementDimension(player)
	local interior = getElementInterior(player)
	
	setElementDimension(player, getElementDimension(car))
	setElementInterior(player, getElementInterior(car))
	if warpPedIntoVehicle(player, car, ...) then
		exports['anticheat-system']:changeProtectedElementDataEx(player, "realinvehicle", 1, false)
		return true
	else
		setElementDimension(player, dimension)
		setElementInterior(player, interior)
	end
	return false
end

function enterCar(thePlayer, commandName, targetPlayerName, targetVehicle, seat)
	if exports.global:isPlayerHeadAdmin(thePlayer) then
		targetVehicle = tonumber(targetVehicle)
		seat = tonumber(seat)
		if targetPlayerName and targetVehicle then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer then
				local theVehicle = exports.pool:getElement("vehicle", targetVehicle)
				if theVehicle then
					if seat then
						local occupant = getVehicleOccupant(theVehicle, seat)
						if occupant then
							removePedFromVehicle(occupant)
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has put " .. targetPlayerName .. " onto your seat.", occupant)
							exports['anticheat-system']:changeProtectedElementDataEx(occupant, "realinvehicle", 0, false)
						end
						
						if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
							
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
							outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", targetPlayer)
						else
							outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
						end
					else
						local found = false
						local maxseats = getVehicleMaxPassengers(theVehicle) or 2
						for seat = 0, maxseats  do
							local occupant = getVehicleOccupant(theVehicle, seat)
							if not occupant then
								found = true
								if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
									outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
									outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", targetPlayer)
								else
									outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
								end
								break
							end
						end
						
						if not found then
							outputChatBox("No free seats.", thePlayer, 255, 0, 0)
						end
					end
				else
					outputChatBox("Vehicle not found", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("Parancs: /" .. commandName .. " [player] [car ID] [seat]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("entercar", enterCar, false, false)
addCommandHandler("gotoincar", enterCar, false, false)

function respawnAllVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if commandName then
			if isTimer(respawnTimer) then
				outputChatBox("Már van egy Respawn parancs ami fut, /respawnstop megállithatod", thePlayer, 255, 0, 0)
			else
				timeToRespawn = tonumber(timeToRespawn) or 30
				timeToRespawn = timeToRespawn < 10 and 10 or timeToRespawn
				for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
					local logged = getElementData(arrayPlayer, "loggedin")
					if (logged) then
						if exports.global:isPlayerLeadAdmin(arrayPlayer) then
							outputChatBox( "Admin: " .. getPlayerName(thePlayer) .. " Respawnol minden járművet", arrayPlayer, 255, 194, 14)
						end
					end
				end
				
				outputChatBox("*** Minden jármű respawnolva lesz "..timeToRespawn.." másodperc múlva! ***", getRootElement(), 255, 0, 0)
				outputChatBox("(Megállíthatod a '/respawnstop' paranccsal!)", thePlayer)
				respawnTimer = setTimer(respawnAllVehicles, timeToRespawn*1000, 1, thePlayer)
			end
			return
		end
		local tick = getTickCount()
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		local tempcounter = 0
		local tempoccupied = 0
		local occupiedcounter = 0
		local unlockedcivs = 0
		local notmoved = 0
		
		local dimensions = { }
		for k, p in ipairs(getElementsByType("player")) do
			dimensions[ getElementDimension( p ) ] = true
		end
		
		for k, theVehicle in ipairs(vehicles) do
			if isElement( theVehicle ) then
				local dbid = getElementData(theVehicle, "dbid")
				if not (dbid) or (dbid<0) then -- TEMP vehicle
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dbid and dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						tempoccupied = tempoccupied + 1
					else
						destroyElement(theVehicle)
						tempcounter = tempcounter + 1
					end
				else
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						occupiedcounter = occupiedcounter + 1
					else
						if isVehicleBlown(theVehicle) then --or isElementInWater(theVehicle) then
							fixVehicle(theVehicle)
							if armoredCars[ getElementModel( theVehicle ) ] then
								setVehicleDamageProof(theVehicle, true)
							else
								setVehicleDamageProof(theVehicle, false)
							end
							for i = 0, 5 do
								setVehicleDoorState(theVehicle, i, 4) -- all kind of stuff missing
							end
							setElementHealth(theVehicle, 300) -- lowest possible health
							exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 1, false)
						end
						
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:left')
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:right')
						if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0 then
							if isElementAttached(theVehicle) then
								detachElements(theVehicle)
							end
							respawnVehicle(theVehicle)
							setVehicleLocked(theVehicle, false)
							unlockedcivs = unlockedcivs + 1
						else 
							local checkx, checky, checkz = getElementPosition( theVehicle )
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
							
							if (round(checkx, 6) == x) and (round(checky, 6) == y) then
								notmoved = notmoved + 1
							else
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								setElementPosition(theVehicle, x, y, z)
								setVehicleRotation(theVehicle, rx, ry, rz)
								counter = counter + 1
							end
						end
						
						setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
						setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
						
						-- fix faction vehicles
						if getElementData(theVehicle, "faction") ~= -1 then
							fixVehicle(theVehicle)
							if (getElementData(theVehicle, "Impounded") == 0) then
								exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 0, false)
								exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
								setTimer(setElementFrozen, 2000, 1, theVehicle, true)
								if armoredCars[ getElementModel( theVehicle ) ] then
									setVehicleDamageProof(theVehicle, true)
								else
									setVehicleDamageProof(theVehicle, false)
								end
							end
						end
					end
				end
			end
		end
		local timeTaken = (getTickCount() - tick)/1000
		outputChatBox(" =-=-=-=-=-=- Minden jármű respawnolva =-=-=-=-=-=-=")
		outputChatBox("" .. counter .. "/" .. counter + notmoved .. " jármű respawnolva. (" .. occupiedcounter .. " foglalt) .", thePlayer)
		outputChatBox("" .. tempcounter .. " ideiglenes jármű törölve. (" .. tempoccupied .. " foglalt).", thePlayer)
		outputChatBox("" .. unlockedcivs .. " civil autó ki lett nyitva és respawnolva.", thePlayer)
		outputChatBox("Mindezt " .. timeTaken .." másodperc alatt.", thePlayer)
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function respawnVehiclesStop(thePlayer, commandName)
	if exports.global:isPlayerSuperAdmin(thePlayer) and isTimer(respawnTimer) then
		killTimer(respawnTimer)
		respawnTimer = nil
		if commandName then
			local name = getPlayerName(thePlayer):gsub("_", " ")
			if getElementData(thePlayer, "hiddenadmin") == 1 then
				name = "Rejtett Admin"
			end
			outputChatBox( "*** " .. name .. " megszakította a jármű respawnt. ***", getRootElement(), 255, 194, 14)
		end
	end
end
addCommandHandler("respawnstop", respawnVehiclesStop, false, false)

function respawnAllCivVehicles(thePlayer, commandName)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			local dbid = getElementData(theVehicle, "dbid")
			if dbid and dbid > 0 then
				if getElementData(theVehicle, "owner") == -2 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then				
						if isElementAttached(theVehicle) then
							detachElements(theVehicle)
						end
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:left')
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:right')
						respawnVehicle(theVehicle)
						setVehicleLocked(theVehicle, false)
						setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
						setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
						counter = counter + 1
					end
				end
			end
		end
		outputChatBox(" =-=-=-=-=-=- Civil járművek respawnolva =-=-=-=-=-=-=")
		outputChatBox("" .. counter .. " civil autó respawnolva lett.", thePlayer)
	end
end
addCommandHandler("respawnciv", respawnAllCivVehicles, false, false)



function respawnCmdVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerSuperAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("Parancs: /respawnveh [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				if isElementAttached(theVehicle) then
					detachElements(theVehicle)
				end
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:left')
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:right')
				local dbid = getElementData(theVehicle,"dbid")
				if (dbid<0) then -- TEMP vehicle
					fixVehicle(theVehicle) -- Can't really respawn this, so just repair it
					if armoredCars[ getElementModel( theVehicle ) ] then
						setVehicleDamageProof(theVehicle, true)
					else
						setVehicleDamageProof(theVehicle, false)
					end
					setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 0, false)
				else
					exports.logs:dbLog(thePlayer, 6, theVehicle, "RESPAWN")
					respawnVehicle(theVehicle)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
						setVehicleLocked(theVehicle, false)
					end
				end
				outputChatBox("Jármű Helyrerakva", thePlayer, 255, 194, 14)
			else
				outputChatBox("Hibás Jármű ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("respawnveh", respawnCmdVehicle, false, false)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end



-- /gotocar
function gotoCar(thePlayer, commandName, id)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("Parancs: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ( ( math.cos ( math.rad ( rz ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rz ) ) ) * 5 )
				
				setElementPosition(thePlayer, x, y, z)
				setPedRotation(thePlayer, rz)
				setElementInterior(thePlayer, getElementInterior(theVehicle))
				setElementDimension(thePlayer, getElementDimension(theVehicle))
				
				exports.logs:dbLog(thePlayer, 6, theVehicle, "GOTOCAR")
				outputChatBox("Sikeresen oda teleportáltál a kocsihoz.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Hibás Kocsi id.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotocar", gotoCar, false, false)


-- /getcar
function getCar(thePlayer, commandName, id)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("Parancs: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local r = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
				
				if	(getElementHealth(theVehicle)==0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end
				
				setElementInterior(theVehicle, getElementInterior(thePlayer))
				setElementDimension(theVehicle, getElementDimension(thePlayer))

				exports.logs:dbLog(thePlayer, 6, theVehicle, "GETCAR")
				outputChatBox("Sikeresen magadhoz teleportáltad.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Hibás Kocsi id.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getcar", getCar, false, false)


-- /oldcar
function getOldCarID(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.global:isPlayerHeadAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end

	local oldvehid = getElementData(thePlayer, "lastvehid")
	
	if not (oldvehid) then
		outputChatBox("Nem ültél kocsiban.", showPlayer, 255, 0, 0)
	else
		outputChatBox("Utolsó kocsi amiben ültél: " .. tostring(oldvehid) .. ".", showPlayer, 255, 194, 14)
	end
end
addCommandHandler("oldcar", getOldCarID, false, false)

-- /veh
local leadplus = { [425] = true, [520] = true, [447] = true, [432] = true, [444] = true, [556] = true, [557] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [476] = true }
function createTempVehicle(thePlayer, commandName, ...)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		local args = {...}
		if (#args < 1) then
			outputChatBox("Parancs: /" .. commandName .. " [id/név] [szin1] [szin2]", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1 = #args ~= 1 and tonumber(args[#args - 1]) or -1
			local col2 = #args ~= 1 and tonumber(args[#args]) or -1
			
			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = #args
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd - 1
				until vehicleID or vehicleEnd == -1
				if vehicleEnd == -1 then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				elseif vehicleEnd == #args - 2 then
					col2 = -1
				elseif vehicleEnd == #args - 1 then
					col1 = -1
					col2 = -1
				end
			end
			
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			if vehicleID then
				local plate = tostring( getElementData(thePlayer, "account:id") )
				if #plate < 8 then
					plate = " " .. plate
					while #plate < 8 do
						plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
						if #plate < 8 then
						end
					end
				end
				
				if leadplus[ vehicleID ] and not exports.global:isPlayerLeadAdmin(thePlayer) then
					outputChatBox( "Insufficient access.", thePlayer, 255, 0, 0)
					return
				end
				
				local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)
				
				if not (veh) then
					outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
				else
					if (armoredCars[vehicleID]) then
						setVehicleDamageProof(veh, true)
					end

					totalTempVehicles = totalTempVehicles + 1
					local dbid = (-totalTempVehicles)
					exports.pool:allocateElement(veh, dbid)
					
					setVehicleColor(veh, col1, col2, col1, col2)
					
					setElementInterior(veh, getElementInterior(thePlayer))
					setElementDimension(veh, getElementDimension(thePlayer))
					
					setVehicleOverrideLights(veh, 1)
					setVehicleEngineState(veh, false)
					setVehicleFuelTankExplodable(veh, false)
					setVehicleVariant(veh, exports['vehicle-system']:getRandomVariant(getElementModel(veh)))
					
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "dbid", dbid)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "Impounded", 0)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "engine", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldx", x, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldy", y, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldz", z, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "faction", -1)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "owner", -1, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "job", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "handbrake", 0, false)
					outputChatBox(getVehicleName(veh) .. " spawned with TEMP ID " .. dbid .. ".", thePlayer, 255, 194, 14)
					
					exports['vehicle-interiors']:add( veh )
					exports.logs:dbLog(thePlayer, 6, thePlayer, "VEH ".. vehicleID .. " created with ID " .. dbid)
				end
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("veh", createTempVehicle, false, false)