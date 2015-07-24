backupBlip = false
backupPlayer = nil

function removeBackup(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) or (getTeamName(thePlayerTeam) == "Hex Tow 'n Go" and getElementData(thePlayer, "factionleader") == 1) then
		if (backupPlayer~=nil) then
			
			for k,v in ipairs(getPlayersInTeam ( getTeamFromName("Hex Tow 'n Go") )) do
				triggerClientEvent(v, "destroyBackupBlip3", backupBlip)
			end
			removeEventHandler("onPlayerQuit", backupPlayer, destroyBlip)
			removeEventHandler("savePlayer", backupPlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = false
			outputChatBox("Lefoglalás törölve!", thePlayer, 255, 194, 14)
		else
			outputChatBox("Hibás lefoglalás.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("resettowbackup", removeBackup, false, false)

function backup(thePlayer, commandName)
	local duty = tonumber(getElementData(thePlayer, "duty"))
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	
	--if (factionType==3 or getTeamName(thePlayerTeam) == "Hex Tow 'n Go") then--Leaving this in in case of abuse.
		if (backupBlip == true) and (backupPlayer~=thePlayer) then -- in use
			outputChatBox("Már hívtál erősitést.", thePlayer, 255, 194, 14)
		elseif (backupBlip == false) then -- make backup blip
			backupBlip = true
			backupPlayer = thePlayer
			for k,v in ipairs(getPlayersInTeam(getTeamFromName("Hex Tow 'n Go"))) do
				triggerClientEvent(v, "createBackupBlip3", thePlayer)
				outputChatBox("A játékosnak szüksége van egy vontatóra. Kérem válaszololjo!", v, 255, 194, 14)
			end

			addEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			addEventHandler("savePlayer", thePlayer, destroyBlip)
			outputChatBox("Bekapcsolta a GPSt'.", thePlayer, 0, 255, 0)
		elseif (backupBlip == true) and (backupPlayer==thePlayer) then -- in use by this player
			destroyBlip( )
			outputChatBox("Kikapcsolta a gps-t'.", thePlayer, 255, 0, 0)
		end
	--end
end
addCommandHandler("towtruck", backup, false, false)

function destroyBlip()
	for key, value in ipairs(getPlayersInTeam(getTeamFromName("Hex Tow 'n Go"))) do
		outputChatBox("Nem igényel segitséget", value, 255, 194, 14)
	end
	for k,v in ipairs(getPlayersInTeam ( getTeamFromName("Hex Tow 'n Go") )) do
		triggerClientEvent(v, "destroyBackupBlip3", backupBlip)
	end
	if source and isElement(source) then
		removeEventHandler("onPlayerQuit", source, destroyBlip)
		removeEventHandler("savePlayer", source, destroyBlip)
	end
	backupPlayer = nil
	backupBlip = false
end