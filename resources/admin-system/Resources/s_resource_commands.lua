function restartSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("Parancs: /restartres [Resources neve.]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if getResourceState(theResource) == "running" then
					restartResource(theResource)
					outputChatBox("Resource " .. resourceName .. " Újraindult!", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " elindult!", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " nem tudja elindítani! (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " nem lehet elindítani (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
				
			else
				outputChatBox("Hibás resources név!.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartres", restartSingleResource)
 
function stopSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /stopres [Resource neve]", thePlayer, 0, 0, 255)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if stopResource(theResource) then
					outputChatBox("Resource " .. resourceName .. " resources sikeresen leállítva!", thePlayer, 0, 0, 255)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " stopped the resource '" .. resourceName .. "'.")
				else
					outputChatBox("Couldn't stop Resource " .. resourceName .. ".", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource nem található!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("stopres", stopSingleResource)
 
function startSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /startres [Resource Name]", thePlayer, 0, 255, 45)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if getResourceState(theResource) == "running" then
					outputChatBox("Resource " .. resourceName .. " is already started.", thePlayer, 0, 0, 255)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " sikeresen elindítva!", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("A resources nem található!.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startres", startSingleResource)

function restartGateKeepers(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		local theResource = getResourceFromName("gatekeepers-system")
		if theResource then
			if getResourceState(theResource) == "running" then
				restartResource(theResource)
				outputChatBox("Gatekeepers sikeresen újraindítva!", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the gatekeepers.")
				--exports.logs:logMessage("[STEVIE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." restarted the gatekeepers." , 25)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "loaded" then
				startResource(theResource)
				outputChatBox("Gatekeepers sikeresen elindítva!", thePlayer, 0, 64, 255)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the gatekeepers.")
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "failed to load" then
				outputChatBox("Gatekeepers nem tud megfelelően betölteni! (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartgatekeepers", restartGateKeepers)