mysql = exports.mysql


	





----smyli rendszer by maxi

function mosoly(thePlayer)
    exports.global:sendLocalMeAction(thePlayer, "Mosolyog.")
end
addCommandHandler(":)", mosoly )

function nevet(thePlayer)
    exports.global:sendLocalMeAction(thePlayer, "nevet.")
end
addCommandHandler(":D", nevet )

function hnevet(thePlayer)
    exports.global:sendLocalMeAction(thePlayer, "Hangosan nevet.")
	exports.global:applyAnimation(thePlayer, "RAPPING", "Laugh_01", -1, true, false, false)
end
addCommandHandler("xd", hnevet )

function szomoru(thePlayer)
    exports.global:sendLocalMeAction(thePlayer, "szomorú.")
end
addCommandHandler(":(", szomoru )

function modolas(jatekos)
   outputChatBox("Módolás:Parancs:/kocsik,ezzel tudod ki,illetve bekapcsolni a módolást a kocsin",jatekos, 0, 255, 0)
   outputChatBox("Módolás:Parancs:/skinek,ezzel tudod ki,illetve bekapcsolni a módolást a skineken",jatekos, 0, 255, 0)
end
addCommandHandler( "modolás", modolas)


MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end










function advertMessage(thePlayer, commandName, showNumber, ...)
	--local canIAD = getElementData(thePlayer, "sanAdvert") or 0
	--if (canIAD == 0) then
	---	outputChatBox("(( Parancs letitva. Keress fel egy híradóst. ))", thePlayer)
	--else
		local logged = tonumber(getElementData(thePlayer, "loggedin"))

		if (logged==1) then
			if not (...) or not (showNumber) then
				outputChatBox("HASZNÁLD: /" .. commandName .. " [Telefonszám mutatása 0/1] [Üzenet]", thePlayer, 255, 194, 14)
			elseif getElementData(thePlayer, "adminjailed") then
				outputChatBox("Börtönben nem tudsz hirdetni.", thePlayer, 255, 0, 0)
			elseif getElementData(thePlayer, "alcohollevel") and getElementData(thePlayer, "alcohollevel") ~= 0 then
				outputChatBox("Túl részeg vagy a hirdetés feladásához!", thePlayer, 255, 0, 0)
			else
				if (exports.global:hasItem(thePlayer, 2)) then
					if (getElementData(thePlayer, "ads") or 0) >= 50 then
						outputChatBox("5 percenként maximum 2 hirdetést tudsz feladni.", thePlayer, 255, 0, 0)
						return
					end
					message = table.concat({...}, " ")
					if showNumber ~= "0" and showNumber ~= "1" then
						message = showNumber .. " " .. message
						showNumber = 0
					end
					if message:sub(-1) ~= "." then
						message = message .. "."
					end
					
					local cost = math.ceil(string.len(message)/0.004)
					if exports.global:takeMoney(thePlayer, cost) then
						local name = getPlayerName(thePlayer)
						local phoneNumber = getElementData(thePlayer, "cellnumber")
						
						exports.logs:logMessage(": " .. message .. ". ((" .. name .. "))", 2)
						for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
							if (getElementData(value, "loggedin")==1 and not getElementData(value, "disableAds")) then
							    outputChatBox("================== [ Postai Hírdetés ]==================", value, 255, 255, 0)
								outputChatBox("   HÍRDETÉS: ".. message .. "", value, 0, 255, 64)
								outputChatBox("   FELADÓ: ".. name .. "", value, 0, 255, 64)
								--outputChatBox("   TELEFONSZÁM: ".. phoneNumber .. "", value, 0, 255, 64)
								outputChatBox("================== [ Postai Hírdetés ]==================", value, 255, 255, 0)
								if (tonumber(showNumber)==1) then
									outputChatBox("   Telefonszám: " .. phoneNumber .. ".", value, 0, 255, 64)
								end
							end
						end
						outputChatBox("Hirdetésed összesen:" .. cost .. "Ft-ba került. Köszönjük.", thePlayer)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "ads", ( getElementData(thePlayer, "ads") or 0 ) + 1, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "sanAdvert", 0)
						setTimer(
							function(p)
								if isElement(p) then
									local c =  getElementData(p, "ads") or 0
									if c > 1 then
										exports['anticheat-system']:changeProtectedElementDataEx(p, "ads", c-1, false)
									else
										exports['anticheat-system']:changeProtectedElementDataEx(p, "ads")
									end
								end
							end, 300000, 1, thePlayer
						)
					else
						outputChatBox("Ez egy kicsit drága lennne... Nincs ennyi pénz nálad", thePlayer)
					end
				else
					outputChatBox("Mobil nélkül nehéz lesz...", thePlayer, 255, 0, 0)
				end
			end
		end
	--end
end
addCommandHandler("hirdetes", advertMessage, false, false)



function trunklateText(thePlayer, text, factor)
	if getElementData(thePlayer,"alcohollevel") and getElementData(thePlayer,"alcohollevel") > 0 then
		local level = math.ceil( getElementData(thePlayer,"alcohollevel") * #text / ( factor or 15 ) )
		for i = 1, level do
			x = math.random( 1, #text )
			-- dont replace spaces
			if text.sub( x, x ) == ' ' then
				i = i - 1
			else
				local a, b = text:sub( 1, x - 1 ) or "", text:sub( x + 1 ) or ""
				local c = ""
				if math.random( 1, 6 ) == 1 then
					c = string.char(math.random(65,90))
				else
					c = string.char(math.random(97,122))
				end
				text = a .. c .. b
			end
		end
	end
	return text
end

function getElementDistance( a, b )
	if not isElement(a) or not isElement(b) or getElementDimension(a) ~= getElementDimension(b) then
		return math.huge
	else
		local x, y, z = getElementPosition( a )
		return getDistanceBetweenPoints3D( x, y, z, getElementPosition( b ) )
	end
end

local gpn = getPlayerName
function getPlayerName(p)
	local name = gpn(p) or getElementData(p, "ped:name")
	return string.gsub(name, "_", " ")
end

-- Main chat: Local IC, Me Actions & Faction IC Radio
function localIC(source, message, language)
	if exports['freecam-tv']:isPlayerFreecamEnabled(source) then return end
	local affectedElements = { }
	table.insert(affectedElements, source)
	local x, y, z = getElementPosition(source)
	local playerName = getPlayerName(source)
	
	message = string.gsub(message, "#%x%x%x%x%x%x", "") -- Remove colour codes
	local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
	message = trunklateText( source, message )
	
	local color = {0xEE,0xEE,0xEE}
	
	local focus = getElementData(source, "focus")
	local focusColor = false
	if type(focus) == "table" then
		for player, color2 in pairs(focus) do
			if player == source then
				color = color2
			end
		end
	end
	local playerVehicle = getPedOccupiedVehicle(source)
	if playerVehicle then
		
		if (exports['vehicle-system']:isVehicleWindowUp(playerVehicle)) then
			table.insert(affectedElements, playerVehicle)
			outputChatBox( " [" .. languagename .. "] " .. playerName .. " ((Autóban)) mondja: " .. message, source, unpack(color))
		else
			outputChatBox( " [" .. languagename .. "] " .. playerName .. " mondja: " .. message, source, unpack(color))
		end
	else
		outputChatBox( " [" .. languagename .. "] " .. playerName .. " mondja: " .. message, source, unpack(color))
		--exports.global:applyAnimation(source, "LOWRIDER", "RAP_B_Loop", 2000, false, true, true)

	end

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)
	local shownto = 1
	
	if dimension ~= 0 then
		table.insert(affectedElements, "in"..tostring(dimension))
	end
	
	
	
	

	
	for key, nearbyPlayer in ipairs(getElementsByType( "player" )) do
		local dist = getElementDistance( source, nearbyPlayer )
		
		if dist < 20 then
			local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
			local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

			if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
				local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
				if not (isPedDead(nearbyPlayer)) and (logged==1) and (nearbyPlayer~=source) then
					local message2 = call(getResourceFromName("language-system"), "applyLanguage", source, nearbyPlayer, message, language)
					message2 = trunklateText( nearbyPlayer, message2 )
					
					local pveh = getPedOccupiedVehicle(source)
					local nbpveh = getPedOccupiedVehicle(nearbyPlayer)
					local color = {0xEE,0xEE,0xEE}
					
					local focus = getElementData(nearbyPlayer, "focus")
					local focusColor = false
					if type(focus) == "table" then
						for player, color2 in pairs(focus) do
							if player == source then
								focusColor = true
								color = color2
							end
						end
					end
					if pveh then
						if (exports['vehicle-system']:isVehicleWindowUp(pveh)) then
							for i = 0, getVehicleMaxPassengers(pveh) do
								local lp = getVehicleOccupant(pveh, i)
								
								if (lp) and (lp~=source) then
									outputChatBox(" [" .. languagename .. "] " .. playerName .. " ((Autóban)) mondja: " .. message2, lp, unpack(color))
									table.insert(affectedElements, lp)
								end
							end
							if (getElementData(nearbyPlayer, "adminduty") == 1) and (getPedOccupiedVehicle(nearbyPlayer) ~= pveh) then
								outputChatBox(" [" .. languagename .. "] " .. playerName .. " ((Autóban)) mondja: " .. message2, nearbyPlayer, unpack(color))
							end
							
							table.insert(affectedElements, pveh)
							exports.logs:dbLog(source, 7, affectedElements, languagename.." AUTÓBAN: ".. message)
							return
						end
					end
					if nbpveh and exports['vehicle-system']:isVehicleWindowUp(nbpveh) then
						if not focusColor then
							if dist < 3 then
							elseif dist < 6 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 9 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 12 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						 --setPedAnimation ( thePlayer, "ROB_BANK", "CAT_Safe_Rob", -1, true, false, false, false)
						outputChatBox(" [" .. languagename .. "] " .. playerName .. " mondja: " .. message2, nearbyPlayer, unpack(color))
						table.insert(affectedElements, nearbyPlayer)
					else
						if not focusColor then
							if dist < 4 then
							elseif dist < 8 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 12 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 16 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						outputChatBox(" [" .. languagename .. "] " .. playerName .. " mondja: " .. message2, nearbyPlayer, unpack(color))
						table.insert(affectedElements, nearbyPlayer)
					end
					
					shownto = shownto + 1
				end
			end
		end
	end
	exports.logs:dbLog(source, 7, affectedElements, languagename..": ".. message)
	exports['freecam-tv']:add(shownto, playerName .. " mondja: " .. message, source)
	--exports.global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)

end

for i = 1, 3 do
	addCommandHandler( tostring( i ), 
		function( thePlayer, commandName, ... )
			local lang = tonumber( getElementData( thePlayer, "languages.lang" .. i ) )
			if lang ~= 0 then
				localIC( thePlayer, table.concat({...}, " "), lang )
			end
		end
	)
end

function meEmote(source, cmd, ...)
	local logged = getElementData(source, "loggedin")
	if not(isPedDead(source) and (logged == 1)) then
		local message = table.concat({...}, " ")
		if not (...) then
			outputChatBox("Parancs: /me [cselekvés]", source, 255, 194, 14)
		else
			local result, affectedPlayers = exports.global:sendLocalMeAction(source, message)
			exports.logs:dbLog(source, 12, affectedPlayers, message)
		end
	end
end
addCommandHandler("ME", meEmote, false, true)
addCommandHandler("Me", meEmote, false, true)

function outputChatBoxCar( vehicle, target, text1, text2, color )
	if vehicle and exports['vehicle-system']:isVehicleWindowUp( vehicle ) then
		if getPedOccupiedVehicle( target ) == vehicle then
			outputChatBox( text1 .. " ((Autóban))" .. text2, target, unpack(color))
			return true
		else
			return false
		end
	end
	outputChatBox( text1 .. text2, target, unpack(color))
	return true
end

function radio(source, radioID, message)
	local affectedElements = { }
	local indirectlyAffectedElements = { }
	table.insert(affectedElements, source)
	radioID = tonumber(radioID) or 1
	local hasRadio, itemKey, itemValue, itemID = exports.global:hasItem(source, 6)
	if hasRadio or getElementType(source) == "ped" or radioID == -2 then
		local theChannel = itemValue
		if radioID < 0 then
			theChannel = radioID
		elseif radioID == 1 and exports.global:isPlayerAdmin(source) and tonumber(message) and tonumber(message) >= 1 and tonumber(message) <= 10 then
			return
		elseif radioID ~= 1 then
			local count = 0
			local items = exports['item-system']:getItems(source)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == radioID then
						theChannel = v[2]
						break
					end
				end
			end
		end
		
		if theChannel == 1 or theChannel == 0 then
			outputChatBox("Kérjük Hangolja a rádiót először /tuneradio [csatorna]", source, 255, 194, 14)
		elseif theChannel > 1 or radioID < 0 then
			triggerClientEvent (source, "playRadioSound", getRootElement())
			local username = getPlayerName(source)
			local languageslot = getElementData(source, "languages.current")
			local language = getElementData(source, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			local channelName = "#" .. theChannel
			
			message = trunklateText( source, message )
			local r, g, b = 0, 102, 255
			local focus = getElementData(source, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == source then
						r, g, b = unpack(color)
					end
				end
			end

			if radioID == -1 then
				local teams = {
					getTeamFromName("Los Santos Police Department"),
					getTeamFromName("State Police"),
					getTeamFromName("Los Santos Medical Services"),
					getTeamFromName("Los Santos Fire Department"),
					getTeamFromName("Hex Tow 'n Go"),
					getTeamFromName("Government of Los Santos"),
					getTeamFromName("First Court of San Andreas"),
					getTeamFromName("Los Santos International Airport"),
					getTeamFromName("San Andreas Network")
				}

				for _, faction in ipairs(teams) do
					if faction and isElement(faction) then
						for key, value in ipairs(getPlayersInTeam(faction)) do
							for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
								if (itemRow[1] == 6 and itemRow[2] > 0) then
									table.insert(affectedElements, value)
									break
								end
							end
						end
					end
				end
				
				channelName = "Sürgősségi"
			elseif radioID == -2 then
				local a = {}
				for key, value in ipairs(exports.lsia:getPlayersInAircraft( )) do
					table.insert(affectedElements, value)
					a[value] = true
				end
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos International Airport" ) ) ) do
					if not a[value] then
						for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
							if (itemRow[1] == 6 and itemRow[2] > 0) then
								table.insert(affectedElements, value)
								break
							end
						end
					end
				end
				
				channelName = "AIR"
			else
				for key, value in ipairs(getElementsByType( "player" )) do
					if exports.global:hasItem(value, 6, theChannel) then
						table.insert(affectedElements, value)
					end
				end
			end
			outputChatBoxCar(getPedOccupiedVehicle( source ), source, "[" .. languagename .. "] [" .. channelName .. "] " .. username, " mondja: " .. message, {r,g,b})
			
			for i = #affectedElements, 1, -1 do
				if getElementData(affectedElements[i], "loggedin") ~= 1 then
					table.remove( affectedElements, i )
				end
			end
			
			for key, value in ipairs(affectedElements) do
				if value ~= source then
					triggerClientEvent (value, "playRadioSound", getRootElement())
					local message2 = call(getResourceFromName("language-system"), "applyLanguage", source, value, message, language)
					local r, g, b = 0, 102, 255
					local focus = getElementData(value, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == source then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBoxCar( getPedOccupiedVehicle( value ), value, "[" .. languagename .. "] [" .. channelName .. "] " .. username, " mondja: " .. trunklateText( value, message2 ), { r, g, b } )
					
					if not exports.global:hasItem(value, 88) == false then
						-- Show it to people near who can hear his radio
						for k, v in ipairs(exports.global:getNearbyElements(value, "player",7)) do
							local logged2 = getElementData(v, "loggedin")
							if (logged2==1) then
								local found = false
								for kx, vx in ipairs(affectedElements) do
									if v == vx then
										found = true
										break
									end
								end
								
								if not found then
									local message2 = call(getResourceFromName("language-system"), "applyLanguage", source, v, message, language)
									local text1 = "[" .. languagename .. "] " .. getPlayerName(value) .. "'s Radio"
									local text2 = ": " .. trunklateText( v, message2 )
									
									if outputChatBoxCar( getPedOccupiedVehicle( value ), v, text1, text2, {255, 255, 255} ) then
										table.insert(indirectlyAffectedElements, v)
									end
								end
							end
						end
					end
				end
			end
			-- 
			--Show the radio to nearby listening in people near the speaker
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDistance(source, value) < 10 then
					if (value~=source) then
						local message2 = call(getResourceFromName("language-system"), "applyLanguage", source, value, message, language)
						local text1 = "[" .. languagename .. "] " .. getPlayerName(source) .. " [RADIO]"
						local text2 = " mondja: " .. trunklateText( value, message2 )
						--exports.global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)

						
						if outputChatBoxCar( getPedOccupiedVehicle( source ), value, text1, text2, {255, 255, 255} ) then
							table.insert(indirectlyAffectedElements, value)
						end
					end
				end
			end
			
			if #indirectlyAffectedElements > 0 then
				table.insert(affectedElements, "Indirectly Affected:")
				for k, v in ipairs(indirectlyAffectedElements) do
					table.insert(affectedElements, v)
				end
			end
			exports.logs:dbLog(source, radioID < 0 and 10 or 9, affectedElements, ( radioID < 0 and "" or ( theChannel .. " " ) ) ..languagename.." "..message)
		else
			outputChatBox("Radio kikacsolva. ((/toggleradio))", source, 255, 0, 0)
		end
	else
		outputChatBox("Nincs radio-d.", source, 255, 0, 0)
	end
end

function chatMain(message, messageType)
	if exports['freecam-tv']:isPlayerFreecamEnabled(source) then cancelEvent() return end
	
	local logged = getElementData(source, "loggedin")
	
	if not (isPedDead(source)) and (logged==1) and not (messageType==2) then -- Player cannot chat while dead or not logged in, unless its OOC
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)
		-- Local IC
		if (messageType==0) then
			local languageslot = getElementData(source, "languages.current")
			local language = getElementData(source, "languages.lang" .. languageslot)
			localIC(source, message, language)
		elseif (messageType==1) then -- Local /me action
			meEmote(source, "me", message)
		end
	elseif (messageType==2) and (logged==1) then -- Radio
		radio(source, 1, message)
	end
end
addEventHandler("onPlayerChat", getRootElement(), chatMain)

function msgRadio(thePlayer, commandName, ...)
	if (...) then
		local message = table.concat({...}, " ")
		radio(thePlayer, 1, message)
	else
		outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("r", msgRadio, false, false)
addCommandHandler("radio", msgRadio, false, false)

for i = 1, 20 do
	addCommandHandler( "r" .. tostring( i ), 
		function( thePlayer, commandName, ... )
			if i <= exports['item-system']:countItems(thePlayer, 6) then
				if (...) then
					radio( thePlayer, i, table.concat({...}, " ") )
				else
					outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
				end
			end
		end
	)
end

function govAnnouncement(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)
	
	if (theTeam) then
		local teamID = tonumber(getElementData(theTeam, "id"))
	
		if (teamID==1 or teamID==2 or teamID==3 or teamID==4 or teamID==5 or teamID==12) then
			local message = table.concat({...}, " ")
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			
			if (factionRank<3) then
				outputChatBox("Nincs elég rangod a hazsnálatához min:rang 3.", thePlayer, 255, 0, 0)
			elseif #message == 0 then
				outputChatBox("Parancs: " .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
			else
				local ranks = getElementData(theTeam,"ranks")
				local factionRankTitle = ranks[factionRank]
				
				--exports.logs:logMessage("[IC: Government Message] " .. factionRankTitle .. " " .. getPlayerName(thePlayer) .. ": " .. message, 6)
				exports.logs:dbLog(source, 16, source, message)
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					local logged = getElementData(value, "loggedin")
					
					if (logged==1) then
						outputChatBox(">> Felhívás  " .. factionRankTitle .. " " .. getPlayerName(thePlayer), value, 0, 183, 239)
						outputChatBox(message, value, 0, 244, 244)
					end
				end
			end
		end
	end
end
addCommandHandler("gov", govAnnouncement)

function playerToggleDonatorChat(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	local hasPerk, perkValue = exports.donators:hasPlayerPerk(thePlayer, 10)
	if (logged==1 and hasPerk) then
		local enabled = getElementData(thePlayer, "donatorchat")
		if (tonumber(perkValue)==1) then
			outputChatBox("You have now hidden Donator Chat.", thePlayer, 255, 194, 14)
			exports.donators:updatePerkValue(thePlayer, 10, 0)
		else
			outputChatBox("You have now enabled Donator Chat.", thePlayer, 255, 194, 14)
			exports.donators:updatePerkValue(thePlayer, 10, 1)
		end
	end
end
addCommandHandler("toggledonatorchat", playerToggleDonatorChat, false, false)
addCommandHandler("toggledon", playerToggleDonatorChat, false, false)
addCommandHandler("toggledchat", playerToggleDonatorChat, false, false)

function donatorchat(thePlayer, commandName, ...)
	if ( exports.donators:hasPlayerPerk(thePlayer, 10) or exports.global:isPlayerAdmin(thePlayer) ) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local logged = tonumber(getElementData(thePlayer, "loggedin"))
			if (logged ~= 1) then
				return
			end
		
			local affectedElements = { }
			table.insert(affectedElements, thePlayer)
			local message = table.concat({...}, " ")
			local title = ""
			local hidden = getElementData(thePlayer, "hiddenadmin") or 0
				
			for key, value in ipairs(getElementsByType("player")) do
				local hasAccess, isEnabled = exports.donators:hasPlayerPerk(value, 10)
				local logged = tonumber(getElementData(value, "loggedin"))
				if (logged == 1) and (hasAccess or exports.global:isPlayerAdmin(value) ) then
					if ( tonumber(isEnabled) ~= 0 ) then
						table.insert(affectedElements, value)
						outputChatBox("[Donator] " .. getPlayerName(thePlayer) .. ": " .. message, value, 160, 164, 104)
					end
				end
			end
			exports.logs:dbLog(thePlayer, 17, affectedElements, message)
		end
	end
end
addCommandHandler("donator", donatorchat, false, false)
addCommandHandler("don", donatorchat, false, false)
addCommandHandler("dchat", donatorchat, false, false)

function departmentradio(thePlayer, commandName, ...)
	local theTeam = getElementType(thePlayer) == "player" and getPlayerTeam(thePlayer)
	local tollped = getElementType(thePlayer) == "ped" and getElementData(thePlayer, "toll:key")
	if (theTeam)  or (tollped) then
		local teamID = nil
		if not tollped then
			teamID = tonumber(getElementData(theTeam, "id"))
		end

		if (teamID==1 or teamID==2 or teamID==3 or teamID==4 or teamID == 30 or teamID == 71 or teamID == 36 or teamID == 64 or teamID == 87 or tollped) then
			if (...) then
				local message = table.concat({...}, " ")
				radio(thePlayer, -1, message)
			elseif not tollped then
				outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("d", departmentradio, false, false)
addCommandHandler("department", departmentradio, false, false)

function airradio(thePlayer, commandName, ...)
	local playersInAir = exports.lsia:getPlayersInAircraft( )
	if playersInAir then
		local found = false
		if getPlayerTeam( thePlayer ) == getTeamFromName( "Los Santos International Airport" ) then
			for _, itemRow in ipairs(exports['item-system']:getItems(thePlayer)) do 
				if (itemRow[1] == 6 and itemRow[2] > 0) then
					found = true
					break
				end
			end
		end
		
		if not found then
			for k, v in ipairs( playersInAir ) do
				if v == thePlayer then
					found = true
					break
				end
			end
		end
		
		if found then
			if not ... then
				outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
			else
				radio(thePlayer, -2, table.concat({...}, " "))
			end
		else
			outputChatBox("Nope.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("air", airradio, false, false)
addCommandHandler("airradio", airradio, false, false)

function blockChatMessage()
	cancelEvent()
end
addEventHandler("onPlayerChat", getRootElement(), blockChatMessage)
-- End of Main Chat

function globalOOC(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	
	if (logged==1) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local oocEnabled = exports.global:getOOCState()
			message = table.concat({...}, " ")
			local muted = getElementData(thePlayer, "muted")
			if (oocEnabled==0) and not (exports.global:isPlayerAdmin(thePlayer)) then
				outputChatBox("OOC Chat is currently disabled.", thePlayer, 255, 0, 0)
			elseif (muted==1) then
				outputChatBox("You are currenty muted from the OOC Chat.", thePlayer, 255, 0, 0)
			else	
				local affectedElements = { }
				local players = exports.pool:getPoolElementsByType("player")
				local playerName = getPlayerName(thePlayer)
				local playerID = getElementData(thePlayer, "playerid")
					
				--exports.logs:logMessage("[OOC: Global Chat] " .. playerName .. ": " .. message, 1)
				for k, arrayPlayer in ipairs(players) do
					local logged = tonumber(getElementData(arrayPlayer, "loggedin"))
					local targetOOCEnabled = getElementData(arrayPlayer, "globalooc")

					if (logged==1) and (targetOOCEnabled==1) then
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("(( (" .. playerID .. ") " .. playerName .. ": " .. message .. " ))", arrayPlayer, 196, 255, 255)
					end
				end
				exports.logs:dbLog(thePlayer, 18, affectedElements, message)
			end
		end
	end
end
addCommandHandler("ooc", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)

function playerToggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local playerOOCEnabled = getElementData(thePlayer, "globalooc")
		
		if (playerOOCEnabled==1) then
			outputChatBox("You have now hidden Global OOC Chat.", thePlayer, 255, 194, 14)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "globalooc", 0, false)
		else
			outputChatBox("You have now enabled Global OOC Chat.", thePlayer, 255, 194, 14)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "globalooc", 1, false)
		end
		mysql:query_free("UPDATE accounts SET globalooc=" .. mysql:escape_string(getElementData(thePlayer, "globalooc")) .. " WHERE id = " .. mysql:escape_string(getElementData(thePlayer, "account:id")))
	end
end
addCommandHandler("toggleooc", playerToggleOOC, false, false)

local advertisementMessages = { "samp", "SA-MP", "See", "SEE", "Hungary", "szar","Ts","ip", "szerver", "web", "ls-rp", "sincity", "tri0n3", "www.", ".com", "co.cc", ".net", ".co.uk", "everlast", "neverlast", "www.everlastgaming.com", "trueliferp", "truelife"}

function isFriendOf(thePlayer, targetPlayer)
	return exports['social-system']:isFriendOf( getElementData( thePlayer, "account:id"), getElementData( targetPlayer, "account:id" ))
end



function localOOC(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if (logged==1) and not (isPedDead(thePlayer)) then
		local muted = getElementData(thePlayer, "muted")
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		elseif (muted==1) then
			outputChatBox("You are currenty muted from the OOC Chat.", thePlayer, 255, 0, 0)
		else
			local message = table.concat({...}, " ") 
			local result, affectedElements = exports.global:sendLocalText(thePlayer, getPlayerName(thePlayer) .. ": (( " .. message .. " ))", 196, 255, 255)
			exports.logs:dbLog(thePlayer, 8, affectedElements, message)
			--exports.logs:logMessage("[OOC: Local Chat] " .. getPlayerName(thePlayer) .. ": " .. table.concat({...}, " "), 1)
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)

function districtIC(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
	
	if (logged==1) and not (isPedDead(thePlayer)) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local playerName = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			local zonename = exports.global:getElementZoneName(thePlayer)
			local x, y = getElementPosition(thePlayer)
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local playerzone = exports.global:getElementZoneName(value)
				local playerdimension = getElementDimension(value)
				local playerinterior = getElementInterior(value)
				
				if (zonename==playerzone) and (dimension==playerdimension) and (interior==playerinterior) and getDistanceBetweenPoints2D(x, y, getElementPosition(value)) < 200 then
					local logged = getElementData(value, "loggedin")
					if (logged==1) then
						table.insert(affectedElements, value)
						if exports.global:isPlayerAdmin(value) then
							outputChatBox("District IC: " .. message .. " ((".. playerName .."))", value, 255, 255, 255)
						else
							outputChatBox("District IC: " .. message, value, 255, 255, 255)
						end
					end
				end
			end
			exports.logs:dbLog(thePlayer, 13, affectedElements, message)
		end
	end
end
addCommandHandler("district", districtIC, false, false)

function localDo(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [történés]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			--exports.logs:logMessage("[IC: Local Do] * " .. message .. " *      ((" .. getPlayerName(thePlayer) .. "))", 19)
			local result, affectedElements = exports.global:sendLocalDoAction(thePlayer, message)
			exports.logs:dbLog(thePlayer, 14, affectedElements, message)
		end
	end
end
addCommandHandler("do", localDo, false, false)


function localShout(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	local affectedElements = { }
	table.insert(affectedElements, thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [szöveg]", thePlayer, 255, 194, 14)
		else
			local playerName = getPlayerName(thePlayer)
			
			local languageslot = getElementData(thePlayer, "languages.current")
			local language = getElementData(thePlayer, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			
			local message = trunklateText(thePlayer, table.concat({...}, " "))
			local r, g, b = 255, 255, 255
			local focus = getElementData(thePlayer, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == thePlayer then
						r, g, b = unpack(color)
					end
				end
			end
			outputChatBox("[" .. languagename .. "] " .. playerName .. " kiabálja: " .. message .. "!!", thePlayer, r, g, b)
			exports.global:applyAnimation(thePlayer, "RIOT", "RIOT_shout", 1000, false, true, true)
			--exports.logs:logMessage("[IC: Local Shout] " .. playerName .. ": " .. message, 1)
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if getElementDistance( thePlayer, nearbyPlayer ) < 40 then
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
					
					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) and (nearbyPlayer~=thePlayer) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						
						if (logged==1) and not (isPedDead(nearbyPlayer)) then
							table.insert(affectedElements, nearbyPlayer)
							local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
							message2 = trunklateText(nearbyPlayer, message2)
							local r, g, b = 255, 255, 255
							local focus = getElementData(nearbyPlayer, "focus")
							if type(focus) == "table" then
								for player, color in pairs(focus) do
									if player == thePlayer then
										r, g, b = unpack(color)
									end
								end
							end
							outputChatBox("[" .. languagename .. "] " .. playerName .. " shouts: " .. message2 .. "!!", nearbyPlayer, r, g, b)
						end
					end
				end
			end
			exports.logs:dbLog(thePlayer, 19, affectedElements, languagename.." "..message)
		end
	end
end
addCommandHandler("s", localShout, false, false)

function megaphoneShout(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
		
	if not (isPedDead(thePlayer)) and (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local factiontype = getElementData(faction, "type")
		
		if (factiontype==2) or (factiontype==3) or (factiontype==4) then
			local affectedElements = { }
			
			if not (...) then
				outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
			else
				local playerName = getPlayerName(thePlayer)
				local message = trunklateText(thePlayer, table.concat({...}, " "))
				
				local languageslot = getElementData(thePlayer, "languages.current")
				local language = getElementData(thePlayer, "languages.lang" .. languageslot)
				local langname = call(getResourceFromName("language-system"), "getLanguageName", language)
				
				for index, nearbyPlayer in ipairs(getElementsByType("player")) do
					if getElementDistance( thePlayer, nearbyPlayer ) < 40 then
						local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
						local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
						
						if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
							local logged = getElementData(nearbyPlayer, "loggedin")
						
							if (logged==1) and not (isPedDead(nearbyPlayer)) then
								local message2 = message
								if nearbyPlayer ~= thePlayer then
									message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
								end
								table.insert(affectedElements, nearbyPlayer)
								outputChatBox(" [" .. langname .. "] ((" .. playerName .. ")) Megaphone <O: " .. trunklateText(nearbyPlayer, message2), nearbyPlayer, 255, 255, 0)
							end
						end
					end
				end
				exports.logs:dbLog(thePlayer, 20, affectedElements, langname.." "..message)
			end
		else
			outputChatBox("Believe it or not, it's hard to shout through a megaphone you do not have.", thePlayer, 255, 0 , 0)
		end
	end
end
addCommandHandler("m", megaphoneShout, false, false)

local togState = { }
function toggleFaction(thePlayer, commandName, State)
	local pF = getElementData(thePlayer, "faction")
	local fL = getElementData(thePlayer, "factionleader")
	local theTeam = getPlayerTeam(thePlayer)

	if fL == 1 then
		if togState[pF] == false or not togState[pF] then
			togState[pF] = true
			outputChatBox("Faction chat is now disabled.", thePlayer)
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("OOC Faction Chat Disabled", arrayPlayer, 255, 0, 0)
					end
				end
			end
		else
			togState[pF] = false
			outputChatBox("Faction chat is now enabled.", thePlayer)
			for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
				if isElement( arrayPlayer ) then
					if getPlayerTeam( arrayPlayer ) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("OOC Faction Chat Enabled", arrayPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("togglef", toggleFaction)
addCommandHandler("togf", toggleFaction)

function toggleFactionSelf(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) then
		local factionBlocked = getElementData(thePlayer, "chat-system:blockF")
		
		if (factionBlocked==1) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "chat-system:blockF", 0, false)
			outputChatBox("Faction chat is now enabled.", thePlayer, 0, 255, 0)
		else
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "chat-system:blockF", 1, false)
			outputChatBox("Faction chat is now disabled.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togglefactionchat", toggleFactionSelf)
addCommandHandler("togglefaction", toggleFactionSelf)
addCommandHandler("togfaction", toggleFactionSelf)

function factionOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			local playerName = getPlayerName(thePlayer)
			local playerFaction = getElementData(thePlayer, "faction")

			
			if not(theTeam) or (theTeamName=="Citizen") then
				outputChatBox("You are not in a faction.", thePlayer)
			else
				local affectedElements = { }
				table.insert(affectedElements, theTeam)
				local message = table.concat({...}, " ")
				
				if (togState[playerFaction]) == true then
					return
				end
				--exports.logs:logMessage("[OOC: " .. theTeamName .. "] " .. playerName .. ": " .. message, 6)
			
				for index, arrayPlayer in ipairs( getElementsByType( "player" ) ) do
					if isElement( arrayPlayer ) then
						if getElementData( arrayPlayer, "bigearsfaction" ) == theTeam then
							outputChatBox("((" .. theTeamName .. ")) " .. playerName .. ": " .. message, arrayPlayer, 3, 157, 157)
						elseif getPlayerTeam( arrayPlayer ) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("((Faction)) " .. playerName .. ": " .. message, arrayPlayer, 3, 237, 237)
						end
					end
				end
				exports.logs:dbLog(thePlayer, 11, affectedElements, message)
			end
		end
	end
end
addCommandHandler("f", factionOOC, false, false)

function setRadioChannel(thePlayer, commandName, slot, channel)
	slot = tonumber( slot )
	channel = tonumber( channel )
	
	if not channel then
		channel = slot
		slot = 1
	end
	
	if not (channel) then
		outputChatBox("Parancs: /" .. commandName .. " [Radio Slot] [Channel Number]", thePlayer, 255, 194, 14)
	else
		if (exports.global:hasItem(thePlayer, 6)) then
			local count = 0
			local items = exports['item-system']:getItems(thePlayer)
			for k, v in ipairs( items ) do
				if v[1] == 6 then
					count = count + 1
					if count == slot then
						if v[2] > 0 then
							if channel > 1 and channel < 1000000000 then
								if exports['item-system']:updateItemValue(thePlayer, k, channel) then
									outputChatBox("You retuned your radio to channel #" .. channel .. ".", thePlayer)
									exports.global:sendLocalMeAction(thePlayer, "retunes their radio.")
								end
							else
								outputChatBox("You can't tune your radio to that frequency!", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("Your radio is off. ((/toggleradio))", thePlayer, 255, 0, 0)
						end
						return
					end
				end
			end
			outputChatBox("You do not have that many radios.", thePlayer, 255, 0, 0)
		else
			outputChatBox("You do not have a radio!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("tuneradio", setRadioChannel, false, false)

function toggleRadio(thePlayer, commandName, slot)
	if (exports.global:hasItem(thePlayer, 6)) then
		local slot = tonumber( slot )
		local items = exports['item-system']:getItems(thePlayer)
		local titemValue = false
		local count = 0
		for k, v in ipairs( items ) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						titemValue = v[2]
						break
					end
				else
					titemValue = v[2]
					break
				end
			end
		end
		
		-- gender switch for /me
		local genderm = getElementData(thePlayer, "gender") == 1 and "her" or "his"
		
		if titemValue < 0 then
			outputChatBox("You turned your radio on.", thePlayer, 255, 194, 14)
			exports.global:sendLocalMeAction(thePlayer, "turns " .. genderm .. " radio on.")
		else
			outputChatBox("You turned your radio off.", thePlayer, 255, 194, 14)
			exports.global:sendLocalMeAction(thePlayer, "turns " .. genderm .. " radio off.")
		end
		
		local count = 0
		for k, v in ipairs( items ) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						exports['item-system']:updateItemValue(thePlayer, k, ( titemValue < 0 and 1 or -1 ) * math.abs( v[2] or 1))
						break
					end
				else
					exports['item-system']:updateItemValue(thePlayer, k, ( titemValue < 0 and 1 or -1 ) * math.abs( v[2] or 1))
				end
			end
		end
	else
		outputChatBox("You do not have a radio!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toggleradio", toggleRadio, false, false)

-- Admin chat
function adminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerAdmin(thePlayer))  then
		if not (...) then
			outputChatBox("Parancs: /a [üzenet]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			--exports.logs:logMessage("[Admin Chat] " .. username .. ": " .. message, 3)
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if(exports.global:isPlayerAdmin(arrayPlayer)) and (logged==1) then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox(adminTitle .. " " .. username .. ": " .. message, arrayPlayer, 51, 255, 102)
				end
			end
			exports.logs:dbLog(thePlayer, 3, affectedElements, message)
		end
	end
end

addCommandHandler("a", adminChat, false, false)



function leadAdminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { } 
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if (exports.global:isPlayerLeadAdmin(arrayPlayer)) and (logged==1) then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("*4+* " ..adminTitle .. " " .. username .. ": " .. message, arrayPlayer, 204, 102, 255)
				end
			end
			exports.logs:dbLog(thePlayer, 2, affectedElements, message)
		end
	end
end

addCommandHandler("l", leadAdminChat, false, false)

function headAdminChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if(exports.global:isPlayerHeadAdmin(arrayPlayer)) and (logged==1) then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("*5+* " ..adminTitle .. " " .. username .. ": " .. message, arrayPlayer, 255, 204, 51)
				end
			end
			exports.logs:dbLog(thePlayer, 1, affectedElements, message)
		end
	end
end

addCommandHandler("h", headAdminChat, false, false)

-- Misc
local function sortTable( a, b )
	if b[2] < a[2] then
		return true
	end
	
	if b[2] == a[2] and b[4] > a[4] then
		return true
	end
	
	return false
end

function showAdmins(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) then
		local players = exports.global:getAdmins()
		local counter = 0
		
		admins = {}
		outputChatBox("Adminok:", thePlayer)
		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")
			
			if logged == 1 then
				if hiddenAdmin == 0 or exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerScripter(thePlayer) then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "adminlevel" ), getElementData( arrayPlayer, "adminduty" ), getPlayerName( arrayPlayer ) }
				end
			end
		end
		
		table.sort( admins, sortTable )
		
		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.global:getPlayerAdminTitle(arrayPlayer)
			
			if exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerScripter(thePlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"
			end
			
			if(v[3]==1)then
				outputChatBox("    " .. tostring(adminTitle) .. " " .. v[4].." - Szolgálatban", thePlayer, 255, 194, 14)
			else
				outputChatBox("    " .. tostring(adminTitle) .. " " .. v[4], thePlayer)
			end
		end
		
		if #admins == 0 then
			outputChatBox("     Nincs Online Admin", thePlayer)
		end
		
		local players = exports.global:getGameMasters()
		local counter = 0
		
		admins = {}
		outputChatBox("Adminsegédek:", thePlayer)
		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			
			if logged == 1 then
				if exports.global:isPlayerGameMaster(arrayPlayer) then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "account:gmlevel" ), getElementData( arrayPlayer, "account:gmduty" ), getPlayerName( arrayPlayer ) }
				end
			end
		end
		
		table.sort( admins, sortTable )
		
		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.global:getPlayerGMTitle(arrayPlayer)
			
			if exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerScripter(thePlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"
			end
			
			if(v[3] == true)then
				outputChatBox("    " .. tostring(adminTitle) .. " " .. v[4].." - Szolgálatban", thePlayer, 255, 194, 14)
			else
				outputChatBox("    " .. tostring(adminTitle) .. " " .. v[4], thePlayer)
			end
		end
		
		if #admins == 0 then
			outputChatBox("     Nincs Adminsegéd online.", thePlayer)
		end
	end
end
addCommandHandler("admins", showAdmins, false, false)

-- Admin chat
function gmChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.global:isPlayerAdmin(thePlayer)  or exports.global:isPlayerGameMaster(thePlayer))  then
		if not (...) then
			outputChatBox("Parancs: /".. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local message = table.concat({...}, " ")
			local players = exports.pool:getPoolElementsByType("player")
			local username = getPlayerName(thePlayer)
			local adminTitle = "Alien"
			if exports.global:isPlayerAdmin(thePlayer) then
				adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			else
				adminTitle = exports.global:getPlayerGMTitle(thePlayer)
			end
			for k, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
				
				if(exports.global:isPlayerAdmin(arrayPlayer) or exports.global:isPlayerGameMaster(arrayPlayer)) and (logged==1) then
					table.insert(affectedElements, arrayPlayer)
					outputChatBox("[G] "..adminTitle .. " " .. username .. ": " .. message, arrayPlayer,  255, 100, 150)
				end
			end
			exports.logs:dbLog(thePlayer, 24, affectedElements, message)
		end
	end
end

addCommandHandler("g", gmChat, false, false)

function toggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.global:isPlayerAdmin(thePlayer)) then
		local players = exports.pool:getPoolElementsByType("player")
		local oocEnabled = exports.global:getOOCState()
		if (commandName == "togooc") then
			if (oocEnabled==0) then
				exports.global:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					
					if	(logged==1) then
						outputChatBox("OOC Chat Enabled by Admin.", arrayPlayer, 0, 255, 0)
					end
				end
			elseif (oocEnabled==1) then
				exports.global:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					
					if	(logged==1) then
						outputChatBox("OOC Chat Disabled by Admin.", arrayPlayer, 255, 0, 0)
					end
				end
			end
		elseif (commandName == "stogooc") then
			if (oocEnabled==0) then
				exports.global:setOOCState(1)
				
				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "adminlevel")
					
					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("OOC Chat Enabled Silently by Admin " .. getPlayerName(thePlayer) .. ".", arrayPlayer, 0, 255, 0)
					end
				end
			elseif (oocEnabled==1) then
				exports.global:setOOCState(0)
				
				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "adminlevel")
					
					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("OOC Chat Disabled Silently by Admin " .. getPlayerName(thePlayer) .. ".", arrayPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

addCommandHandler("togooc", toggleOOC, false, false)
addCommandHandler("stogooc", toggleOOC, false, false)
		
function togglePM(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and ((exports.global:isPlayerFullGameMaster(thePlayer)) or(exports.global:isPlayerAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer, 1)))then
		local pmenabled = getElementData(thePlayer, "pmblocked")
		
		if (pmenabled==1) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "pmblocked", 0, false)
			outputChatBox("PM's are now enabled.", thePlayer, 0, 255, 0)
			exports.donators:updatePerkValue(thePlayer, 2, 0)
		else
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "pmblocked", 1, false)
			outputChatBox("PM's are now disabled.", thePlayer, 255, 0, 0)
			exports.donators:updatePerkValue(thePlayer, 2, 1)
		end
	end
end
addCommandHandler("togpm", togglePM)
addCommandHandler("togglepm", togglePM)

function toggleAds(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if(logged==1) and (exports.donators:hasPlayerPerk(thePlayer, 2))then
		local adblocked = getElementData(thePlayer, "disableAds")
		if (adblocked) then -- enable the ads again
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "disableAds", false, false)
			outputChatBox("Ads are now enabled.", thePlayer, 0, 255, 0)
			exports.donators:updatePerkValue(thePlayer, 1, 0)
		else -- disable them D:
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "disableAds", true, false)
			outputChatBox("Ads are now disabled.", thePlayer, 255, 0, 0)
			exports.donators:updatePerkValue(thePlayer, 1, 1)
		end
	end
end
addCommandHandler("togad", toggleAds)
addCommandHandler("togglead", toggleAds)

-- /pay
function payPlayer(thePlayer, commandName, targetPlayerNick, amount)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if not (targetPlayerNick) or not (amount) or not tonumber(amount) then
			outputChatBox("Parancs: /" .. commandName .. " [Játékos id] [összeg]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=10) then
					amount = math.floor(math.abs(tonumber(amount)))
					
					local hoursplayed = getElementData(thePlayer, "hoursplayed")
					
					if (targetPlayer==thePlayer) then
						outputChatBox("Magadnak nem tudsz átadni pénzt", thePlayer, 255, 0, 0)
					elseif amount == 0 then
						outputChatBox("Minimum 1 ft", thePlayer, 255, 0, 0)
					elseif (hoursplayed<5) and (amount>50) and not exports.global:isPlayerAdmin(thePlayer) and not exports.global:isPlayerAdmin(targetPlayer) then
						outputChatBox("Minimum 5 játszott óra kell hozzá", thePlayer, 255, 0, 0)
					elseif exports.global:hasMoney(thePlayer, amount) then
						if hoursplayed < 5 and not exports.global:isPlayerAdmin(targetPlayer) and not exports.global:isPlayerAdmin(thePlayer) then
							local totalAmount = ( getElementData(thePlayer, "payAmount") or 0 ) + amount
							
							exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "payAmount", totalAmount, false)
							setTimer(
								function(thePlayer, amount)
									if isElement(thePlayer) then
										local totalAmount = ( getElementData(thePlayer, "payAmount") or 0 ) - amount
										exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "payAmount", totalAmount <= 0 and false or totalAmount, false)
									end
								end,
								300000, 1, thePlayer, amount
							)
						end
						
						--exports.logs:logMessage("[Money Transfer From " .. getPlayerName(thePlayer) .. " To: " .. targetPlayerName .. "] Value: " .. amount .. "$", 5)
						exports.logs:dbLog(thePlayer, 25, targetPlayer, "PAY " .. amount)
						
						if (hoursplayed<5) then
							exports.global:sendMessageToAdmins("Figyelem: Új játékos '" .. getPlayerName(thePlayer) .. "' adott" .. exports.global:formatMoney(amount) .. " neki '" .. targetPlayerName .. "' Ft.")
						end
						
						-- DEAL!
						exports.global:takeMoney(thePlayer, amount)
						exports.global:giveMoney(targetPlayer, amount)
						
						local gender = getElementData(thePlayer, "gender")
						local genderm = "his"
						if (gender == 1) then
							genderm = "her"
						end
						
						
						outputChatBox("Adtál"  .. exports.global:formatMoney(amount)  ..  "Ft-ot"    .. targetPlayerName .. " nek/nak", thePlayer)
						outputChatBox(getPlayerName(thePlayer) ..  "Adott neked"  .. exports.global:formatMoney(amount)   .. " Ft-ot." , targetPlayer)

						exports.global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
					else
						outputChatBox("nincs elég pénzed.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Nincs a közeledben" .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("pay", payPlayer, false, false)

function removeAnimation(thePlayer)
	exports.global:removeAnimation(thePlayer)
end

-- /w(hisper)
function localWhisper(thePlayer, commandName, targetPlayerNick, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	 
	if (logged==1) then
		if not (targetPlayerNick) or not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [Player Partial Nick / ID] [üzenet]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			
			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				
				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<3) then
					local name = getPlayerName(thePlayer)
					local message = table.concat({...}, " ")
					--exports.logs:logMessage("[IC: Whisper] " .. name .. " to " .. targetPlayerName .. ": " .. message, 1)
					exports.logs:dbLog(thePlayer, 21, targetPlayer, message)
					message = trunklateText( thePlayer, message )
					
					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					
					message2 = trunklateText( targetPlayer, message2 )
					local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, targetPlayer, message, language)
					
					exports.global:sendLocalMeAction(thePlayer, "whispers to " .. targetPlayerName .. ".")
					local r, g, b = 255, 255, 255
					local focus = getElementData(thePlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBox("[" .. languagename .. "] " .. name .. " whispers: " .. message, thePlayer, r, g, b)
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					outputChatBox("[" .. languagename .. "] " .. name .. " whispers: " .. message2, targetPlayer, r, g, b)
					for i,p in ipairs(getElementsByType( "player" )) do
						if (getElementData(p, "adminduty") == 1) then
							if p ~= targetPlayer and p ~= thePlayer then
								local ax, ay, az = getElementPosition(p)
								if (getDistanceBetweenPoints3D(x, y, z, ax, ay, az)<4) then
									outputChatBox("[" .. languagename .. "] " .. name .. " whispers to " .. getPlayerName(targetPlayer):gsub("_"," ") .. ": " .. message, p, 255, 255, 255)
								end
							end
						end
					end
				else
					outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("w", localWhisper, false, false)

-- /c(lose)
function localClose(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	
	local logged = tonumber(getElementData(thePlayer, "loggedin"))
	 
	if (logged==1) then
		if not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local name = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			--exports.logs:logMessage("[IC: Whisper] " .. name .. ": " .. message, 1)
			message = trunklateText( thePlayer, message )
			
			local languageslot = getElementData(thePlayer, "languages.current")
			local language = getElementData(thePlayer, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			
			for index, targetPlayers in ipairs( getElementsByType( "player" ) ) do
				if getElementDistance( thePlayer, targetPlayers ) < 5 then
					local message2 = message
					if targetPlayers ~= thePlayer then
						message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, targetPlayers, message, language)
						message2 = trunklateText( targetPlayers, message2 )
					end
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayers, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					local pveh = getPedOccupiedVehicle(targetPlayers)
					if pveh then
						if (exports['vehicle-system']:isVehicleWindowUp(pveh)) then	
							table.insert(affectedElements, targetPlayers)
							outputChatBox( " [" .. languagename .. "] " .. name .. " whispers: " .. message2, targetPlayers, r, g, b)
						end
					else
						table.insert(affectedElements, targetPlayers)
						outputChatBox( " [" .. languagename .. "] " .. name .. " whispers: " .. message2, targetPlayers, r, g, b)
					end
				end
			end
			exports.logs:dbLog(thePlayer, 22, affectedElements, languagename .. " "..message)
		end
	end
end
addCommandHandler("c", localClose, false, false)

------------------
-- News Faction --
------------------
-- /tognews
function togNews(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) and (exports.donators:hasPlayerPerk(thePlayer, 3)) then
		local newsTog = getElementData(thePlayer, "tognews")
		
		if (newsTog~=1) then
			outputChatBox("/news disabled.", thePlayer, 255, 194, 14)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "tognews", 1, false)
			exports.donators:updatePerkValue(thePlayer, 3, 1)
		else
			outputChatBox("/news enabled.", thePlayer, 255, 194, 14)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "tognews", 0, false)
			exports.donators:updatePerkValue(thePlayer, 3, 0)
		end
	end
end
addCommandHandler("tognews", togNews, false, false)
addCommandHandler("togglenews", togNews, false, false)


-- /startinterview
function StartInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("Parancs: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if(getElementData(targetPlayer,"interview"))then
							outputChatBox("This player is already being interviewed.", thePlayer, 255, 0, 0)
						else
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "interview", true, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName .." has offered you for an interview.", targetPlayer, 0, 255, 0)
							outputChatBox("((Use /i to talk during the interview.))", targetPlayer, 0, 255, 0)
							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("((".. playerName .." has invited " .. targetPlayerName .. " for an interview.))", value, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("interview", StartInterview, false, false)

-- /endinterview
function endInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("Parancs: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if not(getElementData(targetPlayer,"interview"))then
							outputChatBox("This player is not being interviewed.", thePlayer, 255, 0, 0)
						else
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "interview", false, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName .." has ended your interview.", targetPlayer, 255, 0, 0)
						
							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("((".. playerName .." has ended " .. targetPlayerName .. "'s interview.))", value, 255, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("endinterview", endInterview, false, false)

-- /i
function interviewChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if(getElementData(thePlayer, "interview"))then
			if not(...)then
				outputChatBox("Parancs: /" .. commandName .. "[üzenet]", thePlayer, 255, 194, 14)
			else
				local message = table.concat({...}, " ")
				local name = getPlayerName(thePlayer)
				
				local finalmessage = "[NEWS] Interview Guest " .. name .." says: ".. message
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				if(factionType==6)then -- news faction
					finalmessage = "[NEWS] " .. name .." says: ".. message
				end
				
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					if (getElementData(value, "loggedin")==1) then
						if not (getElementData(value, "tognews")==1) then
							outputChatBox(finalmessage, value, 200, 100, 200)
						end
					end
				end
				exports.logs:dbLog(thePlayer, 23, thePlayer, "NEWS " .. message)
				exports.global:giveMoney(getTeamFromName"San Andreas Network", 200)
			end
		end
	end
end
addCommandHandler("i", interviewChat, false, false)

-- /charity
function charityCash(thePlayer, commandName, amount)
	if not (amount) then
		outputChatBox("Parancs: /" .. commandName .. " [Amount]", thePlayer, 255, 194, 14)
	else
		local donation = tonumber(amount)
		if (donation<=0) then
			outputChatBox("You must enter an amount greater than zero.", thePlayer, 255, 0, 0)
		else
			if not exports.global:takeMoney(thePlayer, donation) then
				outputChatBox("You don't have that much money to remove.", thePlayer, 255, 0, 0)
			else
				outputChatBox("You have donated $".. exports.global:formatMoney(donation) .." to charity.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmWrn: " ..getPlayerName(thePlayer).. " charity'd $" ..exports.global:formatMoney(donation))
			end
		end
	end
end
addCommandHandler("charity", charityCash, false, false)

-- /bigears
function bigEars(thePlayer, commandName, targetPlayerNick)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		local current = getElementData(thePlayer, "bigears")
		if not current and not targetPlayerNick then
			outputChatBox("Parancs: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
		elseif current and not targetPlayerNick then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "bigears", false, false)
			outputChatBox("Big Ears turned off.", thePlayer, 255, 0, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			
			if targetPlayer then
				outputChatBox("Now Listening to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "BIGEARS "..targetPlayerName)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "bigears", targetPlayer, false)
			end
		end
	end
end
addCommandHandler("bigears", bigEars)

function removeBigEars()
	for key, value in pairs( getElementsByType( "player" ) ) do
		if isElement( value ) and getElementData( value, "bigears" ) == source then
			exports['anticheat-system']:changeProtectedElementDataEx( value, "bigears", false, false )
			outputChatBox("Big Ears turned off (Player Left).", value, 255, 0, 0)
		end
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), removeBigEars)

function bigEarsFaction(thePlayer, commandName, factionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		factionID = tonumber( factionID )
		local current = getElementData(thePlayer, "bigearsfaction")
		if not current and not factionID then
			outputChatBox("Parancs: /" .. commandName .. " [faction id]", thePlayer, 255, 194, 14)
		elseif current and not factionID then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "bigearsfaction", false, false)
			outputChatBox("Big Ears turned off.", thePlayer, 255, 0, 0)
		else
			local team = exports.pool:getElement("team", factionID)
			if not team then
				outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
			else
				outputChatBox("Now Listening to " .. getTeamName(team) .. " OOC Chat.", thePlayer, 0, 255, 0)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "bigearsfaction", team, false)
				exports.logs:dbLog(thePlayer, 4, team, "BIGEARSF "..getTeamName(team))
			end
		end
	end
end
addCommandHandler("bigearsf", bigEarsFaction)

function disableMsg(message, player)
	cancelEvent()

	-- send it using our own PM etiquette instead
	pmPlayer(source, "pm", player, message)
end
addEventHandler("onPlayerPrivateMessage", getRootElement(), disableMsg)


function oocCoin(thePlayer)
	if  math.random( 1, 2 ) == 2 then
		exports.global:sendLocalText(thePlayer, " ((OOC Coin)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " flips an coin, landing on tail.", 255, 51, 102)
	else
		exports.global:sendLocalText(thePlayer, " ((OOC Coin)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " flips an coin, landing on head.", 255, 51, 102)
	end
end
addCommandHandler("flipcoin", oocCoin)

-- /focus
function focus(thePlayer, commandName, targetPlayer, r, g, b)
	local focus = getElementData(thePlayer, "focus")
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			if type(focus) ~= "table" then
				focus = {}
			end
			
			if focus[targetPlayer] and not r then
				outputChatBox( "You stopped highlighting " .. string.format("#%02x%02x%02x", unpack( focus[targetPlayer] ) ) .. targetPlayerName .. "#ffc20e.", thePlayer, 255, 194, 14, true )
				focus[targetPlayer] = nil
			else
				color = {tonumber(r) or math.random(63,255), tonumber(g) or math.random(63,255), tonumber(b) or math.random(63,255)}
				for _, v in ipairs(color) do
					if v < 0 or v > 255 then
						outputChatBox("Invalid Color: " .. v, thePlayer, 255, 0, 0)
						return
					end
				end
				
				focus[targetPlayer] = color
				outputChatBox( "You are now highlighting on " .. string.format("#%02x%02x%02x", unpack( focus[targetPlayer] ) ) .. targetPlayerName .. "#00ff00.", thePlayer, 0, 255, 0, true )
			end
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "focus", focus, false)
		end
	else
		if type(focus) == "table" then
			outputChatBox( "You are watching: ", thePlayer, 255, 194, 14 )
			for player, color in pairs( focus ) do
				outputChatBox( "  " .. getPlayerName( player ):gsub("_", " "), thePlayer, unpack( color ) )
			end
		end
		outputChatBox( "To add someone, /" .. commandName .. " [player] [optional red/green/blue], to remove just /" .. commandName .. " [player] again.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("focus", focus)
addCommandHandler("highlight", focus)

addEventHandler("onPlayerQuit", root,
	function( )
		for k, v in ipairs( getElementsByType( "player" ) ) do
			if v ~= source then
				local focus = getElementData( v, "focus" )
				if focus and focus[source] then
					focus[source] = nil
					exports['anticheat-system']:changeProtectedElementDataEx(v, "focus", focus, false)
				end
			end
		end
	end
)
