function getNearbyInteriors(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		outputChatBox("Közeli Interiorok:", thePlayer, 255, 126, 0)
		local count = 0
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			local interiorEntrance = getElementData(interior, "entrance")
			local interiorExit = getElementData(interior, "exit")
			
			for _, point in ipairs( { interiorEntrance, interiorExit } ) do
				if (point[INTERIOR_DIM] == dimension) then
					local distance = getDistanceBetweenPoints3D(posX, posY, posZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z])
					if (distance <= 11) then
						local dbid = getElementData(interior, "dbid")
						local interiorName = getElementData(interior, "name")
						outputChatBox(" ID " .. dbid .. ": " .. interiorName, thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   Nincs.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyinteriors", getNearbyInteriors, false, false)


function setFee( thePlayer, commandName, theFee )
	if not theFee or not tonumber( theFee ) then
		outputChatBox( "Használat: /" .. commandName .. " [Belépési díj]", thePlayer, 255, 194, 14 )
	else
		local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
		if entrance then
			local interiorEntrance = getElementData(interiorElement, "entrance")
			local interiorStatus = getElementData(interiorElement, "status")
			local interiorName = getElementData(interiorElement, "name")
			local theFee = tonumber( theFee )
			if theFee >= 0 then
				if interiorStatus[INTERIOR_TYPE] == 1 then
					if exports.global:isPlayerAdmin( thePlayer ) or interiorStatus[INTERIOR_OWNER] == getElementData( thePlayer, "dbid" ) then
						
						local canHazFee, intID = false
						if exports.global:isPlayerSuperAdmin( thePlayer ) then
							canHazFee = true
						elseif interiorEntrance[INTERIOR_FEE] then
							canHazFee = true
						end
						
						if canHazFee then
							local query = mysql:query_free("UPDATE interiors SET fee = " .. theFee .. " WHERE id = " .. dbid )
							if query then
								interiorEntrance[INTERIOR_FEE] = theFee
								exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "entrance", interiorEntrance, true)
								outputChatBox( "Belépési díj mostantól a(z) '" .. interiorName .. "'-hoz/hez " .. exports.global:formatMoney(theFee) .. " Forint.", thePlayer, 0, 255, 0 )
								exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETFEE "..theFee)
								
							else
								outputChatBox( "Error 9017 - Jelentsd fórumon.", thePlayer, 255, 0, 0 )
							end
						else
							outputChatBox( "Ehhez az üzlethez nem tudsz belépési díjat hozzáadni, keress fel egy admint.", thePlayer, 255, 0, 0 )
						end
					else
						outputChatBox( "Nem a te üzleted.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Ez nem üzlet, nem tudsz belépési díjat állítani.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "Pozitív értékeket tudsz állítani!", thePlayer, 255, 0, 0 )
			end
		else
			outputChatBox( "Nem vagy interiorban!", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "setfee", setFee )


function gotoHouse( thePlayer, commandName, houseID )
	if exports.global:isPlayerFullAdmin( thePlayer ) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "Használat: /" .. commandName .. " [Ház/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
			if entrance then
				triggerClientEvent(thePlayer, "setPlayerInsideInterior", interiorElement, entrance, interiorElement)			
				outputChatBox( "Elteleportáltál a " .. houseID.."-as/es házhoz.", thePlayer, 0, 255, 0 )
			else
				outputChatBox( "Hibás ház.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "gotohouse", gotoHouse )

function gotoHouseInside( thePlayer, commandName, houseID )
	if exports.global:isPlayerFullAdmin( thePlayer ) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "Használat: /" .. commandName .. " [Ház/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
			if entrance then
				triggerClientEvent(thePlayer, "setPlayerInsideInterior", interiorElement, exit, interiorElement)			
				outputChatBox( "Beteleportáltál a " .. houseID.."-as/es házhoz.", thePlayer, 0, 255, 0 )
			else
				outputChatBox( "Hibás ház.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "gotohousei", gotoHouseInside )

function setInteriorID( thePlayer, commandName, interiorID )
	if exports.global:isPlayerLeadAdmin( thePlayer ) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		interiorID = tonumber( interiorID )
		if not interiorID then
			outputChatBox( "Használat: /" .. commandName .. " [interior ID] - megváltoztatja a ház Interiorját", thePlayer, 255, 194, 14 )
		elseif not interiors[interiorID] then
			outputChatBox( "Hibás ID.", thePlayer, 255, 0, 0 )
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				local interior = interiors[interiorID]
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				
				local query = mysql:query_free( "UPDATE interiors SET interior=" .. interiorw .. ", interiorx=" .. ix .. ", interiory=" .. iy .. ", interiorz=" .. iz .. ", angle=" .. optAngle .. " WHERE id=" .. dbid)
				if query then
					--setInteriorObjects(dbid, interiorID)
					--removeInteriorObjects(dbid)
					cleanupProperty( dbid )
					realReloadInterior(dbid)		

					for key, value in pairs( getElementsByType( "player" ) ) do
						if isElement( value ) and getElementDimension( value ) == dbid then
							setElementPosition( value, ix, iy, iz )
							setElementInterior( value, interiorw )
							setCameraInterior( value, interiorw )
						end
					end
					
					outputChatBox( "Interior Frissítve.", thePlayer, 0, 255, 0 )
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORID "..interiorID)
				else
					outputChatBox( "Interior frissítés sikertelen.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "Nem vagy Interiorban.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriorid", setInteriorID )

function setInteriorPrice( thePlayer, commandName, cost )
	if exports.global:isPlayerLeadAdmin( thePlayer ) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		cost = tonumber( cost )
		if not cost then
			outputChatBox( "Használat: /" .. commandName .. " [ár]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
			if exit then
				local query = mysql:query_free("UPDATE interiors SET cost=" .. cost .. " WHERE id=" .. dbid)
				if query then
					local interiorStatus = getElementData(interiorElement, "status")
					interiorStatus[INTERIOR_COST] = cost
					exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
					exports.logs:logMessage("[/SETINTERIORPRICE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." set the interiorprice of ".. dbid .." to ".. cost , 4)
					outputChatBox( "Az interior ára mostantól " .. exports.global:formatMoney(cost) .. " Forint.", thePlayer, 0, 255, 0 )
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORPRICE "..cost)
				else
					outputChatBox( "Interior frissítése sikertelen.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "Nem vagy interiorban.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriorprice", setInteriorPrice )

function getInteriorPrice( thePlayer )
	if exports.global:isPlayerLeadAdmin( thePlayer ) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
		if exit then
			local interiorStatus = getElementData(interiorElement, "status")
			outputChatBox( "Az interior ára " .. exports.global:formatMoney(interiorStatus[INTERIOR_COST]) .. " Forint.", thePlayer, 255, 194, 14 )
		else
			outputChatBox( "Nem vagy interiorban.", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "getinteriorprice", getInteriorPrice )

function setInteriorType( thePlayer, commandName, type )
	if exports.global:isPlayerLeadAdmin( thePlayer ) or (exports.donators:hasPlayerPerk(thePlayer, 14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		type = math.ceil( tonumber( type ) or -1 )
		if not type or type < 0 or type > 3 then
			outputChatBox( "Használat: /" .. commandName .. " [típus (0-3)]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
			if exit then
				if type ~= interiorType then
					local query = mysql:query_free("UPDATE interiors SET type=" .. type .. " WHERE id='" .. mysql:escape_string(dbid) .."'")
					if query then
						local interiorStatus = getElementData(interiorElement, "status")
						interiorStatus[INTERIOR_TYPE] = type
						outputChatBox( "Interior type is now " .. type .. ".", thePlayer, 0, 255, 0 )
						exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORTYPE "..type .. " (was "..interiorType.." / ".. interiorStatus[INTERIOR_OWNER] ..")")
						if type == 2 then
							local query2 = mysql:query_free("UPDATE interiors SET owner=0 WHERE id='" .. mysql:escape_string(dbid) .."'")
							if query2 then
								interiorStatus[INTERIOR_OWNER] = 0
								outputChatBox( "Beállítottad az interior típust 2-re így nincs birtokosa.", thePlayer, 0, 255, 0 )
							end
						end
						exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
					else
						outputChatBox( "Interior frissítése sikertelen.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Interior már ilyen típusú.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "Nem vagy interiorban.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriortype", setInteriorType )

function getInteriorType( thePlayer )
	if exports.global:isPlayerLeadAdmin( thePlayer ) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
		if exit then
			outputChatBox( "Az interior típusa: " .. interiorType .. ".", thePlayer, 255, 194, 14 )
		else
			outputChatBox( "Nem vagy interiorban.", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "getinteriortype", getInteriorType )

function getInteriorID( thePlayer, commandName )
	local c = 0
	local interior = getElementInterior( thePlayer )
	local x, y, z = getElementPosition( thePlayer )
	for k, v in pairs( interiors ) do
		if interior == v[1] and getDistanceBetweenPoints3D( x, y, z, v[2], v[3], v[4] ) < 10 then
			outputChatBox( "Interior ID: " .. k, thePlayer )
			c = c + 1
		end
	end
	if c == 0 then
		outputChatBox( "Nem található interior ID.", thePlayer )
	end
end
addCommandHandler( "getinteriorid", getInteriorID )

function toggleInterior( thePlayer, commandName, id )
	if exports.global:isPlayerLeadAdmin( thePlayer )  or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		id = tonumber( id )
		if not id then
			outputChatBox( "Használat: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, inttype, interiorElement = findProperty( thePlayer, id )
			if entrance then
				local interiorStatus = getElementData(interiorElement, "status")
				if interiorStatus[INTERIOR_DISABLED] then
					mysql:query_free("UPDATE interiors SET disabled = 0 WHERE id = " .. dbid ) 
					outputChatBox("Interior "..dbid.." mostantól bekapcsolva", thePlayer)
				else
					mysql:query_free("UPDATE interiors SET disabled = 1 WHERE id = " .. dbid )
					outputChatBox("Interior "..dbid.." mostantól kikapcsolva", thePlayer)
				end
				realReloadInterior(dbid)
				exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "TOGGLEINTERIOR "..dbid)
			end
		end
	end
end
addCommandHandler( "toggleinterior", toggleInterior )

function reloadInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not interiorID then
			outputChatBox("Használat: /" .. commandName .. " [Interior ID]", thePlayer, 255, 194, 14)
		else
			local dbid, entrance, exit, interiorType = findProperty( thePlayer, tonumber(interiorID) )
			if dbid ~= 0 then			
				realReloadInterior(dbid)
				outputChatBox("" .. dbid.."-as/es Interior újratöltése", thePlayer, 0, 255, 0)
			else
				if reloadOneInterior(tonumber(interiorID), false) then
					outputChatBox("A " .. tonumber(interiorID) .. "-as/es Interior betöltve.", thePlayer, 0, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("reloadinterior", reloadInterior, false, false)


function deleteInterior(thePlayer, commandName, houseID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "Használat: /" .. commandName .. " [Ház/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit = findProperty( thePlayer,  tonumber(houseID) )
			if dbid ~= 0 then
				-- move all players outside
				for key, value in pairs( getElementsByType( "player" ) ) do
					if isElement( value ) and getElementDimension( value ) == dbid then
						setElementInterior( value, entrance[INTERIOR_INT] )
						setCameraInterior( value, entrance[INTERIOR_INT] )
						setElementDimension( value, entrance[INTERIOR_DIM] )
						setElementPosition( value, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z] )
						exports['anticheat-system']:changeProtectedElementDataEx( value, "interiormarker" )
						
						triggerEvent("onPlayerInteriorChange", value, exit, entrance)
					end
				end
				
				local query = mysql:query_free("DELETE FROM interiors WHERE id='" .. dbid .. "'")
				if (query) then
					local safe = safeTable[dbid]
					if safe then
						call( getResourceFromName( "item-system" ), "clearItems", safe )
						destroyElement(safe)
						safeTable[dbid] = nil
					end
					-- destroy the entrance and exit
					realReloadInterior(dbid)
					intTable[dbid] = nil
					cleanupProperty(dbid)
					outputChatBox("A " .. dbid .. "-as/es interior törölve!", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "DELETEINTERIOR "..dbid)
				else
					outputChatBox("Error 50001 - Jelentsd fórumon.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("delinterior", deleteInterior, false, false)

function deleteThisInterior(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("Nem vagy interiorban.", thePlayer, 255, 0, 0)
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if dbid > 0 then
				-- move all players outside
				for key, value in pairs( getElementsByType( "player" ) ) do
					if isElement( value ) and getElementDimension( value ) == dbid then
						setElementInterior( value, entrance[INTERIOR_INT] )
						setCameraInterior( value, entrance[INTERIOR_INT] )
						setElementDimension( value, entrance[INTERIOR_DIM] )
						setElementPosition( value, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z] )
						exports['anticheat-system']:changeProtectedElementDataEx( value, "interiormarker" )
						
						triggerEvent("onPlayerInteriorChange", value, exit, entrance)
					end
				end				
				local query = mysql:query_free("DELETE FROM interiors WHERE id='" .. dbid .. "'")
				if (query) then
				
					local safe = safeTable[dbid]
					if safe then
						call( getResourceFromName( "item-system" ), "clearItems", safe )
						destroyElement(safe)
						safeTable[dbid] = nil
					end
					-- destroy the entrance and exit
					realReloadInterior(dbid)
					intTable[dbid] = nil
					cleanupProperty(dbid)
					outputChatBox("A " .. dbid .. "-as/es Interior törölve!", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "DELETEINTERIOR "..dbid)
				else
					outputChatBox("Error 50001 - Jelentsd fórumon.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("delthisinterior", deleteThisInterior, false, false)

function updateInteriorEntrance(thePlayer, commandName, intID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local intID = tonumber(intID)
		if not (intID) then
			outputChatBox( "Használat: /" .. commandName .. " [Interior ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit = findProperty(thePlayer, intID)
			if entrance then
				local dw = getElementDimension(thePlayer)
				local iw = getElementInterior(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local rot = getPedRotation(thePlayer)
				local query = mysql:query_free("UPDATE interiors SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', angle='" .. rot .. "', dimensionwithin='" .. dw .. "', interiorwithin='" .. iw .. "' WHERE id='" .. dbid .. "'")
				
				if (query) then
					realReloadInterior(dbid)
					
					outputChatBox("Átállítottad a " .. dbid .. "-as/es számú Interior bejáratát!", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORENTRANCE ("..dw.."/"..iw..") "..x.."/"..y.."/"..z)
				else
					outputChatBox("SQL probléma(s_int_adm/424).", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox( "Hibás Interior ID.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler("setinteriorentrance", updateInteriorEntrance, false, false)


function createInterior(thePlayer, commandName, interiorId, inttype, cost, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local cost = tonumber(cost)
		if not (interiorId) or not (inttype) or not (cost) or not (...) or ((tonumber(inttype)<0) or (tonumber(inttype)>3)) then
			outputChatBox("Használat: /" .. commandName .. " [Interior ID] [Típus] [Ár] [Név]", thePlayer, 255, 194, 14)
			outputChatBox("TÍPUS 0: Ház", thePlayer, 255, 194, 14)
			outputChatBox("TÍPUS 1: Üzlet", thePlayer, 255, 194, 14)
			outputChatBox("TÍPUS 2: Állami (Nem lehet megvenni)", thePlayer, 255, 194, 14)
			outputChatBox("TÍPUS 3: Bérelhető", thePlayer, 255, 194, 14)
		
		else
			name = table.concat({...}, " ")
			
			local x, y, z = getElementPosition(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local interiorwithin = getElementInterior(thePlayer)
			
			local inttype = tonumber(inttype)
			local owner = nil
			local locked = nil
			
			if (inttype==2) then
				owner = 0
				locked = 0
			else
				owner = -1
				locked = 1
			end
			
			interior = interiors[tonumber(interiorId)]
			if interior then
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				
				local rot = getPedRotation(thePlayer)
				local id = SmallestID()
				local query = mysql:query_free("INSERT INTO interiors SET id=" .. id .. ",x='" .. x .. "', y='" .. y .."', z='" .. z .."', type='" .. inttype .. "', owner='" .. owner .. "', locked='" .. locked .. "', cost='" .. cost .. "', name='" .. mysql:escape_string( name) .. "', interior='" .. interiorw .. "', interiorx='" .. ix .. "', interiory='" .. iy .. "', interiorz='" .. iz .. "', dimensionwithin='" .. dimension .. "', interiorwithin='" .. interiorwithin .. "', angle='" .. optAngle .. "', angleexit='" .. rot .. "', fee=0")
				
				if (query) then
					outputChatBox("Csináltál egy interiort: ID " .. id, thePlayer, 255, 194, 14)
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(id) } , "ADDINTERIOR T:".. inttype .." I:"..interiorId.." C:"..cost)
					reloadOneInterior(id, false, false)	
					
				else
					outputChatBox("Nem lehet lerakni az interiort - Tiltott karakterek vannak az interior nevében.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Nem lehet lerakni az interiort - Nincsen ilyen interior (" .. ( interiorID or "??" ) .. ").", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addinterior", createInterior, false, false)

function updateInteriorExit(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local dimension = getElementDimension(thePlayer)
		
		if (dimension==0) then
			outputChatBox("Nem vagy interiorban.", thePlayer, 255, 0, 0)
		else
			local dbid = getElementDimension(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local rot = getPedRotation(thePlayer)
			local query = mysql:query_free("UPDATE interiors SET interiorx='" .. x .. "', interiory='" .. y .. "', interiorz='" .. z .. "', angle='" .. rot .. "', `interior`='".. tostring(interior) .."' WHERE id='" .. dbid .. "'")
			outputChatBox("Interior kijárata frissítve!", thePlayer, 0, 255, 0)
			exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIOREXIT "..x.."/"..y.."/"..z)
			realReloadInterior(dbid)
		end
	end
end
addCommandHandler("setinteriorexit", updateInteriorExit, false, false)

function changeInteriorName( thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then -- Is the player an admin?
		local id = getElementDimension(thePlayer)
		if not (...) then -- is the command complete?
			outputChatBox("Használat: /" .. commandName .." [Új név]", thePlayer, 255, 194, 14) -- if command is not complete show the Használat.
		elseif (dimension==0) then
			outputChatBox("Nem vagy az interiorban.", thePlayer, 255, 0, 0)
		else
			name = table.concat({...}, " ")
		
			mysql:query_free("UPDATE interiors SET name='" .. mysql:escape_string( name) .. "' WHERE id='" .. id .. "'") -- Update the name in the sql.
			outputChatBox("Az interior neve megváltoztatva erre:  ".. name ..".", thePlayer, 0, 255, 0) -- Output confirmation.
			exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORNAME '"..name.."'")
			realReloadInterior(id)
		end
	end
end
addCommandHandler("setinteriorname", changeInteriorName, false, false) -- the command "/setInteriorName".