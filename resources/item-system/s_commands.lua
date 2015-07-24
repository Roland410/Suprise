local badges = getBadges()
local masks = getMasks()

-- Player Commands to use Items
function breathTest(thePlayer, commandName, targetPlayer)
	if (exports.global:hasItem(thePlayer, 53)) then
		if not (targetPlayer) then
			outputChatBox("Használat: /" .. commandName .. " [Név részlet / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("A játékos nincsen bejelentkezve.", thePlayer, 255, 0, 0)
				else
					local alcohollevel = getElementData(targetPlayer, "alcohollevel")
					
					if not (alcohollevel) then alcohollevel = 0 end
					
					outputChatBox(targetPlayerName .. " alkohol szintje: " .. alcohollevel .. ".", thePlayer, 255, 194, 15)
				end
			end
		end
	end
end
addCommandHandler("szonda", breathTest, false, false)

-- /issueBadge Command - A command for faction leaders
function givePlayerBadge(thePlayer, commandName, targetPlayer, ... )
	local badgeNumber = table.concat( { ... }, " " )
	badgeNumber = #badgeNumber > 0 and badgeNumber
	local theTeam = getPlayerTeam(thePlayer)
	local teamID = getElementData(theTeam, "id")
	
	local badge = nil
	local itemID = nil
	local prefix = ""
	for k, v in pairs(badges) do
		for ka, va in pairs(v[3]) do
			if ka == teamID then
				badge = v
				itemID = k
				prefix = type(va) == "string" and ( va .. " " ) or ""
			end
		end
	end
	if not badge then return end
	
	local leader = getElementData(thePlayer, "factionleader")
	
	if not (tonumber(leader)==1) then -- If the player is not the leader
		outputChatBox("Frakció leadernek kell lenned hogy jelvényt kiállíthass.", thePlayer, 255, 0, 0) -- If they aren't leader they can't give out badges.
	else
		if not targetPlayer or not badgeNumber then
			outputChatBox("Használat: /" .. commandName .. " [Név részlet / ID] [Jelvény szám]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then -- is the player online?
				local targetPlayerName = targetPlayerName:gsub("_", " ")
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("A játékos nincsen bejelentkezve.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
						outputChatBox("Túl messze vagy ahhoz hogy jelvényt adj neki.", thePlayer, 255, 0, 0)
					else
						exports.global:sendLocalMeAction(thePlayer, "átadott "..targetPlayerName.."-nak/nek egy  " .. badge[2] .. " jelvényt, ezzel a számmal: " .. badgeNumber .. ".")
						exports.global:giveItem(targetPlayer, itemID, prefix .. badgeNumber)
					end
				end
			end
		end
	end
end
addCommandHandler("jelvenykiallitas", givePlayerBadge, false, false)

function issuePilotCertificate(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("Használat: /" .. commandName .. " [játékos]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(targetPlayer)
			if targetPlayer then -- is the player online?
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("A játékos nincsen bejelentkezve.", thePlayer, 255, 0, 0)
				else
					exports.global:giveItem(targetPlayer, 78, targetPlayerName) -- Give the player the certificate.
				end
			end
		end
	end
end
addCommandHandler("pilótaengedélyadás", issuePilotCertificate, false, false)

function writeNote(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("Használat: /" .. commandName .. " [Szöveg]", thePlayer, 255, 194, 14)
	elseif not hasSpaceForItem( thePlayer, 72, table.concat({...}, " ") ) then
		outputChatBox("Nincs hely a jegyzetnek a zsebedben.", thePlayer, 255, 0, 0)
	else
		local found, slot, itemValue = hasItem( thePlayer, 71 )
		if found then
			
			giveItem( thePlayer, 72, table.concat({...}, " ") )
			exports.global:sendLocalMeAction(thePlayer, "valamit ír egy kis papírra.")
			
			if itemValue > 1 then
				updateItemValue( thePlayer, slot, itemValue - 1 )
			else
				takeItemFromSlot( thePlayer, slot )
			end
		else
			outputChatBox("Nincsen üres papírod.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("jegyzet", writeNote, false, false)

function changeLock(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local dbid = getElementData( theVehicle, "dbid" )
			if dbid > 0 then
				exports.logs:logMessage( "[VEHICLE] " .. getPlayerName( thePlayer ) .. " zárat cserélt egy kocsin #" .. dbid .. " (" .. getVehicleName( theVehicle ) .. ")", 16) 
				deleteAll( 3, dbid )
				giveItem( thePlayer, 3, dbid )
				outputChatBox( "Zár kicserélve.", thePlayer, 0, 255,0  )
			else
				outputChatBox( "Nem lehet csak végleges kocsikon.", thePlayer, 255, 0, 0 )
			end
		else
			local dbid, entrance, exit, interiortype = exports['interior-system']:findProperty( thePlayer )
			if dbid > 0 then
				if interiortype == 2 then
					outputChatBox( "Ez egy állami épület.", thePlayer, 255, 0, 0 )
				else
					local itemid = interiortype == 1 and 5 or 4
					exports.logs:logMessage( "[HOUSE] " .. getPlayerName( thePlayer ) .. " zárat cserélt egy házban #" .. dbid .. ")", 16) 
					deleteAll( 4, dbid )
					deleteAll( 5, dbid )
					giveItem( thePlayer, itemid, dbid )
					outputChatBox( "A ház zárja lecserélve.", thePlayer, 0, 255,0  )
				end
			else
				outputChatBox( "Egy ház/járműben kell lenned ahhoz hogy zárat cserélhess.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler("zárcsere", changeLock, false, false)
