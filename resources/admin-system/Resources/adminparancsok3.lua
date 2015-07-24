mysql = exports.mysql
---ah


function adminSegitseg(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("[========== Adminsegéd Parancsok ==========]", thePlayer, 0, 255, 0)
	if (exports.global:isPlayerAdmin(thePlayer)) then
        outputChatBox("Adminsegéd:/recon,/stoprecon,/goto,/a,/vá,/aduty,asay,/nevek.", thePlayer, 255, 255, 0)
        outputChatBox("[========== Adminsegéd Parancsok ==========]", thePlayer, 0, 255, 0)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
	    outputChatBox("[==========1-es Admin Parancsok ==========]",thePlayer, 0, 255, 240)
	    outputChatBox("Admin1:/jail,", thePlayer, 0, 255, 240)
		outputChatBox("[==========1-es Admin Parancsok ==========]",thePlayer, 0, 255, 240)
    end
	end
	end
end
addCommandHandler("teszt", adminSegitseg)

function adminfelhivas(thePlayer, commandName, ...)--by silenthunter
	if (exports.global:isPlayerAdmin(thePlayer)) then--ha Admin
		if not (...) then
			outputChatBox("HASZNÁLD: /am [Admin Üzenet]", thePlayer, 255, 194, 15)
		else
			local adminrang = exports.global:getPlayerAdminTitle(thePlayer)
			
			message = table.concat({...}, " ")
			local playerName = getPlayerName(thePlayer)
			
			exports.global:sendMessageToAdmins("Asay by ".. playerName .. ":", 0, 250, 0)
			outputChatBox(adminrang .. ": ".. playerName .. ":".. message, getRootElement(), 0, 250, 0,true)
		end
	end
end
addCommandHandler("asay", adminfelhivas, false, false)


function adminDuty(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "adminduty")
		local username = getPlayerName(thePlayer)
		
		if (adminduty==0) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 1)
			outputChatBox("Admin szolgálatba léptél.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " szolgálatba lépett.")
			exports.global:updateNametagColor(thePlayer)
		elseif (adminduty==1) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 0)
			outputChatBox("Kiléptél az Admin szolgálatból.", thePlayer, 0, 255, 240)
			exports.global:updateNametagColor(thePlayer)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " kilépett a szolgálatból.")
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
				    outputChatBox("Privát Üzenetet Kaptál  (" .. playerid .. ") " .. playerName .. ": " .. szoveg, targetPlayer, 255, 255, 0)
					outputChatBox("Üzenetet Küldtél " .. targetName .. ": " .. szoveg, thePlayer, 154, 205, 50)
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
						outputChatBox("Üzenetet kaptál " .. playerName .. ": " .. szoveg, targetPlayer, 154, 205, 50)
					else
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						--outputChatBox("Válaszod neki: " .. targetPlayerName .. ": " .. szoveg, thePlayer, 255, 255, 0)
						outputChatBox("Üzenetet kaptál " .. playerName .. ": " .. szoveg, targetPlayer, 154, 205, 50)
					end
					exports.global:sendMessageToAdmins(playerName .. " válaszolt neki: " .. targetPlayerName, 0, 255, 0)
					exports.global:sendMessageToAdmins("Üzenet: " .. szoveg, 255, 255, 0)
				else
					outputChatBox("Használd a /a parancsot", thePlayer, 255, 0, 0)
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
					outputChatBox(" Teleportáltál hozzá: " .. targetPlayerName .. ".", thePlayer)
					outputChatBox(" Admin " .. username .. " teleportált hozzád. ", targetPlayer)
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
						outputChatBox("Nem tudod megfigyelni", thePlayer, 0, 255, 0)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("Megfigyeled " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						
						if hiddenAdmin == 0 and not exports.global:isPlayerLeadAdmin(thePlayer) then
							local adminTitle = exports.global:getPlayerGMTitle(thePlayer)
							exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. "Megfigyeli" .. targetPlayerName .. ".")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)

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
		outputChatBox("Megfigyelés vége.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("fuckrecon", fuckRecon, false, false)
addCommandHandler("stoprecon", fuckRecon, false, false)






function makePlayerAdmin(thePlayer, commandName, who, rank)
	if (exports.global:isPlayerAdmin(thePlayer)) then
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
addCommandHandler("makeadmin", makePlayerAdmin, false, false)











