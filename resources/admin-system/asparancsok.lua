mysql = exports.mysql
---ah




function adminfelhivas(thePlayer, commandName, ...)--by James
	if (exports.global:isPlayerAdmin(thePlayer)) then--ha Admin
		if not (...) then
			outputChatBox("HASZNÁLD: /asay [Admin Üzenet]", thePlayer, 0, 255, 250)
		else
			local adminrang = exports.global:getPlayerAdminTitle(thePlayer)
			
			message = table.concat({...}, " ")
			local playerName = getPlayerName(thePlayer)
			
			outputChatBox(adminrang .. " ".. playerName .. ": ".. message, getRootElement(), 255, 0, 0,true)
		end
	end
end
addCommandHandler("asay", adminfelhivas, false, false)





function adminDuty(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "adminduty")
		local username = getPlayerName(thePlayer)
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
		
		if (adminduty==0) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 1)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " szolgálatba lépett.")
			outputChatBox(adminTitle .. " " .. username .. " adminszolgálatba lépett." , getRootElement(), 0, 255, 250)
			exports.global:updateNametagColor(thePlayer)
		elseif (adminduty==1) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 0)
			exports.global:updateNametagColor(thePlayer)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " kilépett a szolgálatból.")
			outputChatBox(adminTitle .. " " .. username .. " kilépett az adminszolgálatból." , getRootElement(), 0, 255, 250)
		end
		mysql:query_free("UPDATE accounts SET adminduty=" .. mysql:escape_string(getElementData(thePlayer, "adminduty")) .. " WHERE id = " .. mysql:escape_string(getElementData(thePlayer, "gameaccountid")) )
	end
end
addCommandHandler("aduty", adminDuty, false, false)

function PMNeki(thePlayer, commandName, targetPlayer, ...)
		if not (targetPlayer) or not (...) then
			outputChatBox("HASZNÁLD: /" .. commandName .. " [Névrészlet] [szöveg]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				szoveg = table.concat({...}, " ")
				local adminszolis = getElementData(targetPlayer, "adminduty")
				local gmDuty = getElementData(targetPlayer, "account:gmduty")
                if (adminszolis==1) or (gmDuty) then 
				local rejtettadmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local targetName = getPlayerName(targetPlayer)
					local playerid = getElementData(thePlayer, "playerid")
				    outputChatBox("Üzenetet Kaptál  (" .. playerid .. ") ".. playerName .. "-tól: " .. szoveg, targetPlayer, 255, 255, 0)
					outputChatBox("Üzenetet küldtél " .. targetName .. " részére: " .. szoveg, thePlayer, 154, 205, 50)
				else
					outputChatBox("A-A csak admin/adminsegédnek", thePlayer, 255, 0, 0)
				end
			end
		end
end
addCommandHandler("pm", PMNeki, false, false)

function ValaszNeki(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("HASZNÁLD: /" .. commandName .. " [Névrészlet] [szöveg]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				szoveg = table.concat({...}, " ")
				
				if (exports.global:isPlayerAdmin(targetPlayer) ~= true) then
					local rejtettadmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
			
					if (rejtettadmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						--outputChatBox("Válaszod neki: " .. targetPlayerName .. ": " .. szoveg, thePlayer, 255, 255, 0)
						outputChatBox("Üzenetet kaptál " .. playerName .. "-tól: " .. szoveg, targetPlayer, 154, 205, 50)
					else
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						--outputChatBox("Válaszod neki: " .. targetPlayerName .. ": " .. szoveg, thePlayer, 255, 255, 0)
						outputChatBox("Üzenetet kaptál " .. playerName .. "-ótl: " .. szoveg, targetPlayer, 154, 205, 50)
					end
					exports.global:sendMessageToAdmins(playerName .. " válaszolt " .. targetPlayerName .. "kérdésére.", 0, 255, 0)
					exports.global:sendMessageToAdmins("Üzenet: " .. szoveg, 255, 255, 0)
				else
					outputChatBox("Adminoknak a /a paranccsal üzenhetsz!", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("vá", ValaszNeki, false, false)




function gotoPlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
	
		if not (target) then
			outputChatBox("HASZNÁLD: /" .. commandName .. " [NévRészlet]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("A játékos nincs bejelentkezve.", thePlayer, 255, 0 , 0)
				else
					local x, y, z = getElementPosition(targetPlayer)
					local interior = getElementInterior(targetPlayer)
					local dimension = getElementDimension(targetPlayer)
					local r = getPedRotation(targetPlayer)
					
					-- Maths calculations to stop the player being stuck in the target
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
					
					setCameraInterior(thePlayer, interior)
					
					if (isPedInVehicle(thePlayer)) then
						local veh = getPedOccupiedVehicle(thePlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementInterior(thePlayer, interior)
						setElementDimension(thePlayer, dimension)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
						setElementPosition(veh, x, y, z + 1)
						warpPedIntoVehicle ( thePlayer, veh ) 
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					else
						setElementPosition(thePlayer, x, y, z)
						setElementInterior(thePlayer, interior)
						setElementDimension(thePlayer, dimension)
					end
					outputChatBox( targetPlayerName .. " mellé teleportáltál.", thePlayer)
					outputChatBox( username .. " hozzád teleportált.", targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("goto", gotoPlayer, false, false)

----tv
function reconPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")
			
			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("Parancs: /" .. commandName .. " [Játékos neve/id]", thePlayer, 255, 194, 14)
			else
				detachElements(thePlayer)
			
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recony", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconz", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("Megfigyelés kikapcsolva.", thePlayer, 255, 194, 14)
			end
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local freecamEnabled = exports.freecam:isPlayerFreecamEnabled (thePlayer)
			if freecamEnabled then
				toggleFreecam(thePlayer)
			end
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				else
				
					
					-- avoid circular reconning
					--local attached = { [thePlayer] = targetPlayer }
					--local a = targetPlayer
					--while true do
					--	local b = getElementAttachedTo(a)
					--	if b then
					--		if attached[b] then
					--			outputChatBox("Unable to attach (circular reference).", thePlayer, 255, 0, 0)
					--			return
					--		end
					--		attached[a] = b
					--	else
					--		-- not attached to anything
					--		break
					--	end
					--end
					setElementAlpha(thePlayer, 0)
					
					if getPedOccupiedVehicle ( thePlayer ) then
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0, false)
						removePedFromVehicle(thePlayer)
					end
					
					if ( not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true ) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", x, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recony", y, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconz", z, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconrot", rot, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recondimension", dimension, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)
					
					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)
					
					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)
					
					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end
					
					if not (success) then
						outputChatBox("Nem tudod megfigyelni!", thePlayer, 0, 255, 0)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("Megfigyeled " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						
						if hiddenAdmin == 0 and not exports.global:isPlayerLeadAdmin(thePlayer) then
							local adminTitle = exports.global:getPlayerGMTitle(thePlayer)
							exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. "Megfigyeli:" .. targetPlayerName .. "-t.")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)
addCommandHandler("tv", reconPlayer, false, false)

function fuckRecon(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		local rx = getElementData(thePlayer, "reconx")
		local ry = getElementData(thePlayer, "recony")
		local rz = getElementData(thePlayer, "reconz")
		local reconrot = getElementData(thePlayer, "reconrot")
		local recondimension = getElementData(thePlayer, "recondimension")
		local reconinterior = getElementData(thePlayer, "reconinterior")
		
		detachElements(thePlayer)
		setCameraTarget(thePlayer, thePlayer)
		setElementAlpha(thePlayer, 255)
		
		if rx and ry and rz then
			setElementPosition(thePlayer, rx, ry, rz)
			if reconrot then
				setPedRotation(thePlayer, reconrot)
			end
			
			if recondimension then
				setElementDimension(thePlayer, recondimension)
			end
			
			if reconinterior then
					setElementInterior(thePlayer, reconinterior)
					setCameraInterior(thePlayer, reconinterior)
			end
		end
		
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recony", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconz", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconrot", false, false)
		outputChatBox("Megfigyelést befejezted!", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("fuckrecon", fuckRecon, false, false)
addCommandHandler("stoprecon", fuckRecon, false, false)
addCommandHandler("stoptv", fuckRecon, false, false)