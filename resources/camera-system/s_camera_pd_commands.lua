function toggleTrafficCam(thePlayer, commandName)
	local isLoggedIn = getElementData(thePlayer, "loggedin") or 0
	if (isLoggedIn == 1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		-- factiontype == law
		if (factionType == 2) then
			local resultColshape
			local results = 0
			
			-- get current colshape
			for k, theColshape in ipairs(exports.pool:getPoolElementsByType("colshape")) do
				local isSpeedcam = getElementData(theColshape, "speedcam")
				if (isSpeedcam) then
					if (isElementWithinColShape(thePlayer, theColshape)) then
						resultColshape = theColshape
						results = results + 1
					end
				end
			end
			if (results == 0) then
				outputChatBox("A rendszernek hibája akadt: Nincs közeli trafipax.", thePlayer,255,0,0)
			elseif (results > 1) then
				outputChatBox("A rendszernek hibája akadt: Túl sok trafipax van a közelben.", thePlayer, 255,0,0)
			else
				exports.global:sendLocalText(thePlayer, " *"..getPlayerName(thePlayer):gsub("_", " ") .." a jobb kezével az MDC-je billentyűzetén gépel.", 255, 51, 102)
				local result = toggleTrafficCam(resultColshape)
				if (result == 0) then
					outputChatBox("Hiba történt, kérlek jelentsd a karbantartónál.", thePlayer, 255,0,0)
				elseif (result == 1) then
					outputChatBox("A trafipax ki lett kapcsolva.", thePlayer, 255,0,0)
				else
					outputChatBox("A trafipax be lett kapcsolva.", thePlayer, 0,255,0)
				end
			end
		end
	end
end
addCommandHandler("trafikapcsol", toggleTrafficCam)