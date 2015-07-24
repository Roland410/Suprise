function loadAllPerks( targetPlayer )
	if isElement( targetPlayer ) then
		local logged = getElementData(targetPlayer, "account:loggedin")
		if (logged == true) then
			local gameAccountID = getElementData(targetPlayer, "account:id")
			if (gameAccountID) then
				if (gameAccountID > 0) then
					local mysqlResult = exports.mysql:query("SELECT `perkID`,`perkValue` FROM `donators` WHERE `accountID`='".. tostring(gameAccountID) .."' AND expirationDate > NOW()")
					local perksTable = { }
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perksTable, false)
					if (mysqlResult) then
						while true do
							local mysqlRow = exports.mysql:fetch_assoc(mysqlResult)
							if not mysqlRow then break end
							perksTable[ tonumber(mysqlRow["perkID"]) ] = mysqlRow["perkValue"]
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perksTable, false)
						end
					end
					exports.mysql:free_result(mysqlResult)
					return true
				end
			end
		end
	end
	return false
end

function hasPlayerPerk(targetPlayer, perkID)
	if not isElement( targetPlayer ) then
		return false
	end
	
	if not tonumber(perkID) then
		return false
	end
	
	perkID = tonumber(perkID)
	
	local perkTable = getElementData(targetPlayer, "donation-system:perks")
	if not (perkTable) then
		return false
	end
	
	if (perkTable[ perkID ] == nil) then
		return false
	end

	
	return true, perkTable[ perkID ]
end

function updatePerkValue (targetPlayer, perkID, newValue)
	newValue = tostring(newValue)
	if not tonumber(perkID) then
		return false
	end
	
	perkID = tonumber(perkID)
	
	if (hasPlayerPerk(targetPlayer, perkID)) then
		local gameAccountID = getElementData(targetPlayer, "account:id")
		if (gameAccountID) then
			if (gameAccountID > 0) then
				exports.mysql:query_free("UPDATE `donators` SET `perkValue`='" .. exports.mysql:escape_string(newValue) .. "' WHERE `accountID`='".. tostring(gameAccountID)  .."' AND `perkID`='".. exports.mysql:escape_string(tostring(perkID)) .."'")
				local perkTable = getElementData(targetPlayer, "donation-system:perks")				
				perkTable[ perkID ] = newValue
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perkTable, false)
				return true
			end
		end
	end
	return false
end

function givePlayerPerk(targetPlayer, perkID, perkValue, days, points, ...)
	if not isElement( targetPlayer ) then
		return false, "Belső script hiba 100.1"
	end
	
	if not tonumber(perkID) then
		return false, "Belső script hiba 100.2"
	end
	
	if not perkValue then
		perkValue = 1
	end
	
	if not tonumber(days) then
		return false, "Belső script hiba 100.3"
	end
	
	if not tonumber(points) then
		return false, "Belső script hiba 100.4"
	end
	
	perkValue = tostring(perkValue)
	perkID = tostring(perkID)
	points = tonumber(points)
	local logged = getElementData(targetPlayer, "account:loggedin")
	if (logged == false) then
		return false, "A játékos nincs bejelentkezve"
	end
	
	if not points or points < 0 then
		return false, "Belső script hiba 100.5"
	end
	
	local gameAccountID = getElementData(targetPlayer, "account:id")
	local characterID = getElementData(targetPlayer, "account:character:id")
	if (gameAccountID) then
		if (gameAccountID > 0) then
			-- Handle the special perks first.
			if (tonumber(perkID) == 15) then -- Add a vehicle slot, max 10
				if (characterID and tonumber(characterID) > 0) then
					local currentMaxVehicles = tonumber( getElementData(targetPlayer, "maxvehicles") )
					
					if not currentMaxVehicles then 
						return false, "Hiba 103.1: Nem lehet betölteni a maximum járműveket."
					end
					
					if currentMaxVehicles >= 10 then
						return false, "Elérted a maximum jármű slotot ezen a karakteren"
					end
					
					currentMaxVehicles = currentMaxVehicles + 1
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "maxvehicles", currentMaxVehicles)
					exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
					exports.mysql:query_free("UPDATE `characters` SET `maxvehicles`='"..tostring(currentMaxVehicles).."' WHERE `id`='".. tostring(characterID) .."'")
					loadAllPerks(targetPlayer)
					outputChatBox("Szolgáltatás aktiválva: Maximális járműszám növelése " .. currentMaxVehicles .. "-ra/re.", targetPlayer)
					return true, "Sikeres"
				end
			elseif (tonumber(perkID) == 18) then
				if (characterID and tonumber(characterID) > 0) then
					local parameters = {...}
					local number = tonumber(parameters[1])
					
					local valid, reason = checkValidNumber(number)
					if not valid then
						return false, reason
					end
					
					local mysqlQ = exports.mysql:query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber` = '"..number.."'")
					if exports.mysql:num_rows(mysqlQ) ~= 0 then
						return false, "Ez a szám már foglalt"
					end
					
					if exports.global:giveItem(targetPlayer, 2, number) then
						exports.mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`, `boughtby`) VALUES ('"..tostring(number).."', '".. tostring(characterID) .."')")
						exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
						loadAllPerks(targetPlayer)
						
						triggerClientEvent(targetPlayer, "donation-system:phone:close", targetPlayer)
						outputChatBox("Szolgáltatás aktiválva: Az új számod: " .. number .. ".", targetPlayer)
						return true, "Sikeres"
					else
						return false, "Tele van a zsebed."
					end
				end
			else -- Handle the regular perks
				exports.mysql:query_free("INSERT INTO `donators` (accountID, perkID, perkValue, expirationDate) VALUES ('".. tostring(gameAccountID)  .."', '".. exports.mysql:escape_string(perkID) .."', '".. exports.mysql:escape_string(perkValue) .."', NOW() + interval " .. tostring(days).." day)")
				
				exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
				loadAllPerks(targetPlayer)
				exports.global:updateNametagColor(targetPlayer)
				
				outputChatBox("Szolgáltatás aktiválva", targetPlayer)
				return true, "Sikeres"
			end
		end
	end
	return false, "A játékos nincs bejelentkezve."
end 

function onCharacterSpawn(characterName, factionID)
	loadAllPerks(source)
				
	local togPMperk, togPMstatus = hasPlayerPerk(source, 1)
	if (togPMperk) then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pmblocked", tonumber(togPMstatus), false)
	end
				
	local togADperk, togADstatus = hasPlayerPerk(source, 2)
	if (togADperk) then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "disableAds", tonumber(togadminsADstatus) == 1, false)
	end
			
	local togNewsPerk, togNewsStatus = hasPlayerPerk(source, 3)
	if (togNewsPerk) then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "tognews", tonumber(togNewsStatus), false)
	end

	exports.global:updateNametagColor(source)
end
addEventHandler("onCharacterLogin", getRootElement(), onCharacterSpawn)