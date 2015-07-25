mysql = exports.mysql

----2-es admin parancsok



function setPlayerVehicleColor(thePlayer, commandName, target, ...)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (target) or not (...) then
			outputChatBox("Parancs: /" .. commandName .. " [játékos neve/id] [szin ...]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						-- parse colors
						local colors = {...}
						local col = {}
						for i = 1, math.min( 4, #colors ) do
							local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
							if r and g and b then
								col[i] = {r=r, g=g, b=b}
							elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
								col[i] = math.floor(tonumber(colors[i]))
							else
								outputChatBox("Hibás szin: " .. colors[i], thePlayer, 255, 0, 0)
								return
							end
						end
						if not col[2] then col[2] = col[1] end
						if not col[3] then col[3] = col[1] end
						if not col[4] then col[4] = col[2] end
						
						local set = false
						if type( col[1] ) == "number" then
							set = setVehicleColor(veh, col[1], col[2], col[3], col[4])
						else
							set = setVehicleColor(veh, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
						end
						
						if set then
							outputChatBox("Vehicle's color was set.", thePlayer, 0, 255, 0)
							exports['savevehicle-system']:saveVehicleMods(veh)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHICLECOLOR ".. table.concat({...}, " ") )
						else
							outputChatBox("Hibás Szin.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("Játékos nem ül a kocsiban.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)
-----------------------------[GET COLOR]---------------------------------
function getAVehicleColor(thePlayer, commandName, carid)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (carid) then
			outputChatBox("Parancs: /" .. commandName .. " [Car ID]", thePlayer, 255, 194, 14)
		else
			local acar = nil
			for i,c in ipairs(getElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(carid)) then
					acar = c
				end
			end
			if acar then
				local col =  { getVehicleColor(acar, true) }
				outputChatBox("Kocsi szine:", thePlayer)
				outputChatBox("1. " .. col[1].. "," .. col[2] .. "," .. col[3] .. " = " .. ("#%02X%02X%02X"):format(col[1], col[2], col[3]), thePlayer)
				outputChatBox("2. " .. col[4].. "," .. col[5] .. "," .. col[6] .. " = " .. ("#%02X%02X%02X"):format(col[4], col[5], col[6]), thePlayer)
				outputChatBox("3. " .. col[7].. "," .. col[8] .. "," .. col[9] .. " = " .. ("#%02X%02X%02X"):format(col[7], col[8], col[9]), thePlayer)
				outputChatBox("4. " .. col[10].. "," .. col[11] .. "," .. col[12] .. " = " .. ("#%02X%02X%02X"):format(col[10], col[11], col[12]), thePlayer)
			else
				outputChatBox("Hibás Kocsi ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("getcolor", getAVehicleColor, false, false)



function fuelPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("Parancs: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
						triggerClientEvent(targetPlayer, "syncFuel", veh)
						outputChatBox("Te megtankoltad a " .. targetPlayerName .. " Járművét.", thePlayer)
						outputChatBox("A jármű üzemanyaggal ellátva " .. username .. " által.", targetPlayer)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FUELVEH")
					else
						outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fuelveh", fuelPlayerVehicle, false, false)

function fuelAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			exports['anticheat-system']:changeProtectedElementDataEx(value, "fuel", 100, false)
		end
		outputChatBox("Összes Jármű megtankolva		" .. username .. " által.")
		exports.logs:dbLog(thePlayer, 6, { thePlayer  }, "FUELVEHS" )
	end
end
addCommandHandler("fuelvehs", fuelAllVehicles, false, false)



function marry(thePlayer, commandName, player1, player2)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
		if not player1 or not player2 then
			outputChatBox( "Parancs: /" .. commandName .. " [Játékos] [Játékos]", thePlayer, 255, 194, 14 )
		else
			local player1, player1name = exports.global:findPlayerByPartialNick( thePlayer, player1 )
			if player1 then
				local player2, player2name = exports.global:findPlayerByPartialNick( thePlayer, player2 )
				if player2 then
					-- check if one of the players is already married
					local p1r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData( player1, "dbid" )) )
					if p1r then
						if tonumber( p1r["numbr"] ) == 0 then
							local p2r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData( player2, "dbid" )) )
							if p2r then
								if tonumber( p2r["numbr"] ) == 0 then
									mysql:query_free("UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData( player1, "dbid" )) .. " WHERE id = " .. mysql:escape_string(getElementData( player2, "dbid" )) )
									mysql:query_free("UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData( player2, "dbid" )) .. " WHERE id = " .. mysql:escape_string(getElementData( player1, "dbid" )) ) 
									
									outputChatBox( "Önök mostantol kezdve házastársak " .. player2name .. ".", player1, 0, 255, 0 )
									outputChatBox( "Önök mostantol kezdve házastársak " .. player1name .. ".", player2, 0, 255, 0 )
									
									exports['cache']:clearCharacterName( getElementData( player1, "dbid" ) )
									exports['cache']:clearCharacterName( getElementData( player2, "dbid" ) )
									
									outputChatBox( player1name .. " és " .. player2name .. " házasok", thePlayer, 255, 194, 14 )
								else
									outputChatBox( player2name .. " már házas.", thePlayer, 255, 0, 0 )
								end
							end
						else
							outputChatBox( player1name .. " Már házas.", thePlayer, 255, 0, 0 )
						end
					end
				end
			end
		end
	end
end
addCommandHandler("marry", marry)

function divorce(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
		if not targetPlayer then
			outputChatBox( "Parancs: /" .. commandName .. " [játékos]", thePlayer, 255, 194, 14 )
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayer )
			if targetPlayer then
				local marriedto = mysql:query_fetch_assoc("SELECT marriedto FROM characters WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
				if marriedto then
					local to = tonumber( marriedto["marriedto"] )
					if to > 0 then
						mysql:query_free("UPDATE characters SET marriedto = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						mysql:query_free("UPDATE characters SET marriedto = 0 WHERE marriedto = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						
						exports['cache']:clearCharacterName( getElementData( targetPlayer, "dbid" ) )
						exports['cache']:clearCharacterName( to )
						
						outputChatBox( targetPlayerName .. "Önök mostantol elváltak.", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. "Önök mostantol elváltak.", thePlayer, 255, 194, 14 )
					end
				end
			end
		end
	end
end
addCommandHandler("divorce", divorce)



-- Language commands
function getLanguageByName( language )
	for i = 1, call( getResourceFromName( "language-system" ), "getLanguageCount" ) do
		if language:lower() == call( getResourceFromName( "language-system" ), "getLanguageName", i ):lower() then
			return i
		end
	end
	return false
end

function setLanguage(thePlayer, commandName, targetPlayerName, language, skill)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
		if not targetPlayerName or not language or not tonumber( skill ) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Játékosnév/id] [Nyelv] [Skill]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Játékos nem online.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				local skill = tonumber( skill )
				if not lang then
					outputChatBox( language .. " Hibás nyelv.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "language-system" ), "getLanguageName", lang )
					local success, reason = call( getResourceFromName( "language-system" ), "learnLanguage", targetPlayer, lang, false, skill )
					if success then
						outputChatBox( targetPlayerName .. " tanult " .. langname .. ".", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " nem tudott tanulni " .. langname .. ": " .. tostring( reason ), thePlayer, 255, 0, 0 )
					end
					--exports.logs:logMessage("[/SETLANGUAGE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." learned ".. targetPlayerName .. " " .. langname , 4)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETLANGUAGE "..langname.." "..tostring(skill))
				end
			end
		end
	end
end
addCommandHandler("setlanguage", setLanguage)

function deleteLanguage(thePlayer, commandName, targetPlayerName, language)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
		if not targetPlayerName or not language then
			outputChatBox("SYNTAX: /" .. commandName .. " [Játékos név/id] [nyelv]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Játékos nem online.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				if not lang then
					outputChatBox( language .. " Hibás nyelv.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "language-system" ), "getLanguageName", lang )
					if call( getResourceFromName( "language-system" ), "removeLanguage", targetPlayer, lang ) then
						outputChatBox( targetPlayerName .. " forgot " .. langname .. ".", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " nem tudsz beszélni " .. langname, thePlayer, 255, 0, 0 )
					end
				end
			end
		end
	end
end
addCommandHandler("dellanguage", deleteLanguage)



-- /SETSKIN
function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (skinID) or not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID] [Skin ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0) then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)
					
					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local skin = setElementModel(targetPlayer, tonumber(skinID))
					
					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)
					if not (skin) then
						outputChatBox("Hibás skin ID.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Játékos " .. targetPlayerName .. " Átálitották a skined erre: " .. skinID .. ".", thePlayer, 0, 255, 0)
						mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string(skinID) .. " WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETSKIN "..tostring(skinID))
					end
				else
					outputChatBox("Hibás skin ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)


-- /SETARMOR
function setPlayerArmour(thePlayer, commandName, targetPlayer, armor)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (armor) or not (targetPlayer) then
			outputChatBox("Parancs /" .. commandName .. " [Játékosnév/ ID] [Páncél]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(armor))) == "number") then
					local setArmor = setPedArmor(targetPlayer, tonumber(armor))
					outputChatBox("Player " .. targetPlayerName .. " Kaptál" .. armor .. " páncélt.", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR "..tostring(armor))
				else
					outputChatBox("Hibás Páncél érték.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)





-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Parancs: /" .. commandName .. " [Játékosnév/ ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("Figyelem: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " reconnected " .. targetPlayerName )
				end
				outputChatBox("Player '" .. targetPlayerName .. " kénytelen volt újracsatlakozni", thePlayer, 255, 0, 0)
					
				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, getRootElement(), "Please Reconnect")
				addEventHandler("onPlayerQuit", targetPlayer, function( ) killTimer( timer ) end)
				
				redirectPlayer(targetPlayer)
				
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FRECONNECT")
			end
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)


--/AUNMASK
function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Parancs: /" .. commandName .. " [Játékosnév / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Játékos nem online.", thePlayer, 255, 0, 0)
				else
					local any = false
					local masks = exports['item-system']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, value[1], false, true)
						end
					end
					
					if any then
						outputChatBox("Ön eltávolította a maszkot " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("Játékoson nincs maszk.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("aunmask", adminUnmask, false, false)


--/AUNCUFF
function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("Parancs: /" .. commandName .. " [Játékosnév / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==0) then.
						outputChatBox("", thePlayer, 255, 0, 0)
					else
						outputChatBox("Levette róla a bilincset " .. username .. ".", targetPlayer,0,255,0)
						outputChatBox("Levették rólad a bilincset " .. targetPlayerName .. ".", thePlayer,0,255,0)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
						exports.global:removeAnimation(targetPlayer)
						mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports['item-system']:deleteAll(47, getElementData( targetPlayer, "dbid" ))
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNCUFF")
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)