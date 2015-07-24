mysql = exports.mysql

local smallRadius = 5 --units

-- /ujjlenyomat
function fingerprintPlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) or (factionType==20) or (factionType==21)then
			if not (targetPlayerNick) then
				outputChatBox("Parancs: /" .. commandName .. " [Játékos id]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						local fingerprint = getElementData(targetPlayer, "fingerprint")
						outputChatBox(targetPlayerName .. "'ujjlenyomat: " .. tostring(fingerprint) .. ".", thePlayer, 255, 194, 14)
					else
						outputChatBox("túl messze van" .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("ujjlenyomat", fingerprintPlayer, false, false)

-- /birsag



function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [NÉV RÉSZE] [ÖSSZEG] [OKA]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						amount = tonumber(amount)
						local reason = table.concat({...}, " ")
						
						local money = exports.global:getMoney(targetPlayer)
						local bankmoney = getElementData(targetPlayer, "bankmoney")
						
						local takeFromCash = math.min( money, amount )
						local takeFromBank = amount - takeFromCash
						exports.global:takeMoney(targetPlayer, takeFromCash)
							
							
						-- Distribute money between the PD and Government
						local tax = exports.global:getTaxAmount()
								
						exports.global:giveMoney( getTeamFromName("ORFK"), math.ceil((1-tax)*amount) )
						exports.global:giveMoney( getTeamFromName("Nav"), math.ceil(amount) )
						
						outputChatBox("Megbüntetted " .. targetPlayerName .. " összesen " .. amount .. " Ft-ra. Ebből az okból: " .. reason .. ".", thePlayer,0, 255, 0 )
						outputChatBox("Megbüntettek téged " .. amount .. " Ft-ra" .. getPlayerName(thePlayer) .. " által. Ebből az okból: " .. reason .. ".", targetPlayer,0, 255, 0 )
						if takeFromBank > 0 then
							outputChatBox("Mivel nincs nálad ennyi készpénz " .. takeFromBank .. " ezért a bankszámládról vonjuk le ezt az összeget", targetPlayer,0, 255, 0 )
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney - takeFromBank)
						end
						exports.logs:logMessage("[PD/TICKET] " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a ticket. Amount: Ft".. amount.. " Reason: "..reason , 30)
					else
						outputChatBox("Túl messze vagy tőle: " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("birság", ticketPlayer, false, false)




function takeLicense(thePlayer, commandName, targetPartialNick, licenseType, hours)

	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
	
		if (ftype==2) or exports.global:isPlayerAdmin(thePlayer) then
			if not (targetPartialNick) then
				outputChatBox("Parancs: /" .. commandName .. " [Játékos id] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
			else
				hours = tonumber(hours)
				if not (licenseType) or not (hours) or hours < 0 or (hours > 10 and not exports.global:isPlayerAdmin(thePlayer)) then
					outputChatBox("Parancs: /" .. commandName .. " [Játékos id] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
				else
					local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPartialNick)
					if targetPlayer then
						local name = getPlayerName(thePlayer)
						
						if (tonumber(licenseType)==1) then
							if(tonumber(getElementData(targetPlayer, "license.car")) == 1) then
								mysql:query_free("UPDATE characters SET car_license='" .. mysql:escape_string(-hours) .. "' WHERE id=" .. mysql:escape_string(getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name.." has revoked your driving license.", targetPlayer, 255, 194, 14)
								outputChatBox("You have revoked " .. targetPlayerName .. "'s driving license.", thePlayer, 255, 194, 14)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license.car", -hours, false)
								exports.logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their driving license for  "..hours.." hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a driving license.", thePlayer, 255, 0, 0)
							end
						elseif (tonumber(licenseType)==2) then
							if(tonumber(getElementData(targetPlayer, "license.gun")) == 1) then
								mysql:query_free("UPDATE characters SET gun_license='" .. mysql:escape_string(-hours) .. "' WHERE id=" .. mysql:escape_string(getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name.." has revoked your weapon license.", targetPlayer, 255, 194, 14)
								outputChatBox("You have revoked " .. targetPlayerName .. "'s weapon license.", thePlayer, 255, 194, 14)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license.gun", -hours, false)
								exports.logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their gun license for  "..hours.." hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a weapon license.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("License type not recognised.", thePlayer, 255, 194, 14)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("takelicense", takeLicense, false, false)

function tellNearbyPlayersVehicleStrobesOn()
	for _, nearbyPlayer in ipairs(exports.global:getNearbyElements(source, "player", 300)) do
		triggerClientEvent(nearbyPlayer, "forceElementStreamIn", source)
	end
end
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), tellNearbyPlayersVehicleStrobesOn)