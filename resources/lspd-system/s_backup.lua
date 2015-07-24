local backupColours = {
	{ 255, 0, 0, "Vörös", false },
	{ 0, 255, 0, "Zöld", false },
	{ 0, 0, 255, "Kék", false },
	{ 255, 255, 0, "Sárga", false },
	{ 255, 0, 255, "Rózsaszin", false },
	{ 0, 255, 255, "Világoskék", false },
	{ 255, 255, 255, "Fehér", false }
}

local allowedFactionTypes = {
	[2] = true,
	[20] = true,
	[21] = true
}

function startBackup(thePlayer) 
	local duty = tonumber(getElementData(thePlayer, "duty"))
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	local factionShortName = ""
	if (allowedFactionTypes[factionType]) and (duty > 0) then
		for a, b in ipairs(split(getTeamName(theTeam), ' ')) do 
			factionShortName = factionShortName .. b:sub( 1, 1) 
		end
	
		local availableColourIndex = false
		local alreadyUsingOne = false
		for index, colorarray in ipairs(backupColours) do
			-- See if there is one available, and if the player is already using one.
			if (backupColours[index][5] == false) and (availableColourIndex == false) then
				availableColourIndex = index
			elseif (backupColours[index][5] == thePlayer) then
				alreadyUsingOne = true
				availableColourIndex = index
			end			
		end
		
		if alreadyUsingOne then
			backupColours[availableColourIndex][5] = false
			for keyValue, theArrayPlayer in ipairs( getElementsByType("player") ) do
				local pTheTeam = getPlayerTeam(theArrayPlayer)
				if pTheTeam then
					local pFactionType = getElementData(pTheTeam, "type")
					if allowedFactionTypes[pFactionType]  then
						local duty = tonumber(getElementData(theArrayPlayer, "duty"))
						if (duty > 0) then
							triggerClientEvent(theArrayPlayer, "destroyBackupBlip", thePlayer, availableColourIndex)
							outputChatBox("A '".. backupColours[availableColourIndex][4]  .."' Egység (" .. factionShortName ..") Lemondta az erősitést,már nincs veszélyben.", theArrayPlayer, 255, 194, 14)
						end
					end	
				end
			end	
		elseif availableColourIndex then
			backupColours[availableColourIndex][5] = thePlayer
			for keyValue, theArrayPlayer in ipairs( getElementsByType("player") ) do
				local pTheTeam = getPlayerTeam(theArrayPlayer)
				if pTheTeam then
					local pFactionType = getElementData(pTheTeam, "type")
					if allowedFactionTypes[pFactionType]  then
						local duty = tonumber(getElementData(theArrayPlayer, "duty"))
						if (duty > 0) then
							triggerClientEvent(theArrayPlayer, "createBackupBlip", thePlayer, availableColourIndex, backupColours[availableColourIndex])
							outputChatBox("Az '".. backupColours[availableColourIndex][4]  .."' egység (" .. factionShortName ..") Erősitést kért!", theArrayPlayer, 255, 194, 14)
						end
					end	
				end
			end		
		else
			outputChatBox("Minden biztonsági jelzők már használatban van.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("bk", startBackup)

function destroyBlips(thePlayer)
	local availableColourIndex = false
	local factionShortName = ""
	for index, colorarray in ipairs(backupColours) do
		if (backupColours[index][5] == thePlayer) then
			availableColourIndex = index
		end		
	end
	
	if availableColourIndex then
		for a, b in ipairs(split(getTeamName(getPlayerTeam(thePlayer)), ' ')) do 
			factionShortName = factionShortName .. b:sub( 1, 1) 
		end
		backupColours[availableColourIndex][5] = false
		for keyValue, theArrayPlayer in ipairs( getElementsByType("player") ) do
			local pTheTeam = getPlayerTeam(theArrayPlayer)
			if pTheTeam then
				local pFactionType = getElementData(pTheTeam, "type")
				if allowedFactionTypes[pFactionType]  then
					triggerClientEvent(theArrayPlayer, "destroyBackupBlip", theArrayPlayer, availableColourIndex)
					local duty = tonumber(getElementData(theArrayPlayer, "duty"))
					if (duty > 0) then
						outputChatBox("A '".. backupColours[availableColourIndex][4]  .."' egység (" .. factionShortName ..") Lemondta az erősitést", theArrayPlayer, 255, 194, 14)
					end
				end	
			end
		end	
	end
end
addEventHandler("onPlayerQuit", getRootElement(), function() destroyBlips(source) end)
addEventHandler("savePlayer", getRootElement(), function() destroyBlips(source) end)

function syncBlips(thePlayer)
	destroyBlips(thePlayer)

	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	local duty = tonumber(getElementData(thePlayer, "duty"))
	if (allowedFactionTypes[factionType]) and (duty > 0) then
		for index, colorarray in ipairs(backupColours) do
			if (backupColours[index][5] ~= false) and (isElement(backupColours[index][5])) then
				triggerClientEvent(thePlayer, "createBackupBlip", backupColours[index][5], index, backupColours[index])
			end			
		end
	end
end
addEventHandler("onCharacterLogin", getRootElement(), function() setTimer(syncBlips, 2500, 1, source) end)
addEventHandler("onPlayerDuty", getRootElement(),  function() setTimer(syncBlips, 500, 1, source) end)
