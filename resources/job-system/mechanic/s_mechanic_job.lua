armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car

local btrdiscountratio = 1.2

-- Full Service
function serviceVehicle(veh)
	if (veh) then
		local mechcost = 0
		if (getElementData(source,"faction")==5) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("Nem rendelkezel elegendő pénzel ezért a szervizelést nem tudjuk elvégezni", source, 255, 0, 0)
		else
			local health = getElementHealth(veh)
			if (health <= 850) then
				health = health + 150
			else
				health = 1000
			end
			
			fixVehicle(veh)
			setElementHealth(veh, health)
			if not getElementData(veh, "Impounded") or getElementData(veh, "Impounded") == 0 then
				exports['anticheat-system']:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
				if armoredCars[ getElementModel( veh ) ] then
					setVehicleDamageProof(veh, true)
				else
					setVehicleDamageProof(veh, false)
				end
			end
			exports.global:sendLocalMeAction(source, " megjavitotta a járművet ")
			exports.logs:dbLog(source, 31, {  veh }, "REPAIR QUICK-SERVICE")
		end
	else
		outputChatBox(".", source, 255, 0, 0)
	end
end
addEvent("serviceVehicle", true)
addEventHandler("serviceVehicle", getRootElement(), serviceVehicle)

function changeTyre( veh, wheelNumber )
	if (veh) then
		local mechcost = 0
		if (getElementData(source,"faction")==5) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("Válaszd ki a kereket.", source, 255, 0, 0)
		else
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates( veh )

			if (wheelNumber==1) then -- front left
				outputDebugString("Bal első.")
				setVehicleWheelStates ( veh, 0, wheel2, wheel3, wheel4 )
			elseif (wheelNumber==2) then -- back left
				outputDebugString("Bal Hátsó.")
				setVehicleWheelStates ( veh, wheel1, wheel2, 0, wheel4 )
			elseif (wheelNumber==3) then -- front right
				outputDebugString("Jobb első.")
				setVehicleWheelStates ( veh, wheel1, 0, wheel2, wheel4 )
			elseif (wheelNumber==4) then -- back right
				outputDebugString("Jobb Hátsó.")
				setVehicleWheelStates ( veh, wheel1, wheel2, wheel3, 0 )
			end
			
			exports.logs:dbLog(source, 31, {  veh }, "REPAIR TIRESWAP")
			exports.global:sendLocalMeAction(source, " kicserélte a kereket")
		end
	end
end
addEvent("tyreChange", true)
addEventHandler("tyreChange", getRootElement(), changeTyre)

function changePaintjob( veh, paintjob )
	if (veh) then
		local mechcost = 0
		if (getElementData(source,"faction")==5) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("You can't afford to repaint this vehicle.", source, 255, 0, 0)
		else
			triggerEvent( "paintjobEndPreview", source, veh )
			if setVehiclePaintjob( veh, paintjob ) then
				local col1, col2 = getVehicleColor( veh )
				if col1 == 0 or col2 == 0 then
					setVehicleColor( veh, 1, 1, 1, 1 )
				end
				exports.logs:logMessage("[/changePaintJob] " .. getPlayerName(source) .." / ".. getPlayerIP(source)  .." OR " .. getPlayerName(client)  .." / ".. getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " their colors to " .. col1 .. "-" .. col2, 29)
				exports.global:sendLocalMeAction(source, " sikeresen átfestette a kocsit.")
				exports.logs:dbLog(source, 6, {  veh }, "MODDING PAINTJOB ".. paintjob)
				exports['savevehicle-system']:saveVehicleMods(veh)
			else
				outputChatBox("Ezen már ez a festés van.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("paintjobChange", true)
addEventHandler("paintjobChange", getRootElement(), changePaintjob)

function editVehicleHeadlights( veh, color1, color2, color3 )
	if (veh) then
		local mechcost = 0
		if (getElementData(source,"faction")==5) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("You can't afford to mod this vehicle.", source, 255, 0, 0)
		else
			triggerEvent( "headlightEndPreview", source, veh )
			if setVehicleHeadLightColor ( veh, color1, color2, color3) then
				exports.logs:logMessage("[/changeHeadlights] " .. getPlayerName(source) .." / ".. getPlayerIP(source)  .." OR " .. getPlayerName(client)  .." / ".. getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " their headlight colors to " .. color1 .. "-" .. color2 .. "-"..color3, 29)
				exports.global:sendLocalMeAction(source, " sikeresen kicerélte a lámpa izzókat.")
				exports['anticheat-system']:changeProtectedElementDataEx(veh, "headlightcolors", {color1, color2, color3}, true)
				exports['savevehicle-system']:saveVehicleMods(veh)
				exports.logs:dbLog(source, 6, {  veh }, "MODDING HEADLIGHT ".. color1 .. " "..color2.." "..color3)
			else
				outputChatBox(" ezen már ugyanaz van.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("editVehicleHeadlights", true)
addEventHandler("editVehicleHeadlights", getRootElement(), editVehicleHeadlights)

 -- 

function changeVehicleUpgrade( veh, upgrade )
	if (veh) then
		local item = false
		local u = upgrades[upgrade - 999]
		if not u then
			outputDebugString( getPlayerName( source ) .. " Sikeresen kicserélted " .. upgrade )
			return
		end
		name = u[1]
		local mechcost = u[2]
		if (getElementData(source,"faction")==5) then
			mechcost = mechcost / btrdiscountratio
		end
		if exports.global:hasItem( source, 114, upgrade ) then
			mechcost = 0
			item = true
		end
		
		if not item and not exports.global:hasMoney( source, mechcost ) then
			outputChatBox("sikeresen hozzáadtad " .. name .. " a kocsihoz.", source, 255, 0, 0)
		else
			for i = 0, 16 do
				if upgrade == getVehicleUpgradeOnSlot( veh, i ) then
					outputChatBox("ezen már ugyanaz van.", source, 255, 0, 0)
					return
				end
			end
			if addVehicleUpgrade( veh, upgrade ) then
				if item then
					exports.global:takeItem(source, 114, upgrade)
				else
					exports.global:takeMoney(source, mechcost)
				end
				exports.logs:logMessage("[changeVehicleUpgrade] " .. getPlayerName(source) .."/ " .. getPlayerIP(source)  .. " OR " .. getPlayerName(client)  .."/ " .. getPlayerIP(client)  .. "  changed vehicle " .. getElementData(veh, "dbid") .. ": added " .. name .. " to the vehicle.", 29)
				exports.global:sendLocalMeAction(source, " Felrakta " .. name .. " kocsira.")
				exports['savevehicle-system']:saveVehicleMods(veh)
				exports.logs:dbLog(source, 6, {  veh }, "MODDING ADDUPGRADE "..name)
			else
				outputChatBox("ezen már ugyanaz van.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("changeVehicleUpgrade", true)
addEventHandler("changeVehicleUpgrade", getRootElement(), changeVehicleUpgrade)

function changeVehicleColour(veh, col1, col2, col3, col4)
	if (veh) then
		local mechcost = 0
		if (getElementData(source,"faction")==5) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.global:takeMoney(source, mechcost) then
			outputChatBox("nincs elegendő pénzed.", source, 255, 0, 0)
		else
			col = { getVehicleColor( veh, true ) }
			
			local color1 = col1 or { col[1], col[2], col[3] }
			local color2 = col2 or { col[4], col[5], col[6] }
			local color3 = col3 or { col[7], col[8], col[9] }
			local color4 = col4 or { col[10], col[11], col[12] }
			
			outputChatBox("1. "..toJSON(color1), source)
			outputChatBox("2. "..toJSON(color2), source)
			outputChatBox("3. "..toJSON(color3), source)
			outputChatBox("4. "..toJSON(color4), source)
			
			if setVehicleColor( veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3],  color3[1], color3[2], color3[3], color4[1], color4[2], color4[3]) then
				exports.logs:logMessage("[repaintVehicle] " .. getPlayerName(source) .." ".. getPlayerIP(source) .." OR ".. getPlayerName(client) .."/"..getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " colors to ".. col1 .. "-" .. col2, 29)
				exports.global:sendLocalMeAction(source, " sikeresen átfestette.")
				exports['savevehicle-system']:saveVehicleMods(veh)
				exports.logs:dbLog(source, 6, {  veh }, "MODDING REPAINT "..toJSON(col))
			end
		end
	end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", getRootElement(), changeVehicleColour)

--Installing and Removing vehicle tinted windows
function changeVehicleTint(veh, stat)
	if veh and stat then
		if stat == 1 then
			local leader = tonumber(getElementData(source, "factionleader"))
			if leader == 1 then
				local mechcost = 0
				if (getElementData(source,"faction")==30) then
					mechcost = mechcost / 2
				end
				if not exports.global:takeMoney(source, mechcost) then
					outputChatBox("You can't afford to add Tint to this vehicle.", source, 255, 0, 0)
				else
					local vehID = getElementData(veh, "dbid")
					exports.global:sendLocalMeAction(source, " sikeresen kicserélte a szélvédőt.")

					local query = mysql:query_free("UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. mysql:escape_string(vehID) .. "'")
					if query then
						for i = 0, getVehicleMaxPassengers(veh) do
							local player = getVehicleOccupant(veh, i)
							if (player) then
								triggerEvent("setTintName", veh, player)
							end
						end
						
						exports['anticheat-system']:changeProtectedElementDataEx(veh, "tinted", true, true)
						outputChatBox("Sikeresen kicserélted a szélvédőt.", source)
						exports.global:sendLocalMeAction(source, "adds tint to the windows.")
						exports.logs:dbLog(source, 6, {  veh }, "MODDING ADDTINT")
						exports.logs:logMessage("[ADD TINT-BTR] " .. getPlayerName(source):gsub("_"," ") .. " has added tint to vehicle #" .. vehID .. " - " .. getVehicleName(veh) .. ".", 9)
					else
						outputChatBox("Nem lehet szólj adminnak", source, 255, 0, 0)				
					end
				end
			else
				outputChatBox("Csak frakció leader", source, 255, 0, 0)
			end
		elseif stat == 2 then
			local mechcost = 0
			if (getElementData(source,"faction")==30) then
				mechcost = mechcost / 2
			end
			if not exports.global:takeMoney(source, mechcost) then
				outputChatBox("You can't afford to add tint to this vehicle.", source, 255, 0, 0)
			else
				local vehID = getElementData(veh, "dbid")
				exports.global:sendLocalMeAction(source, " sikeresen eltávolitotta a szélvédőt.")
			
				local query = mysql:query_free("UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. mysql:escape_string(vehID) .. "'")
				if query then
					for i = 0, getVehicleMaxPassengers(veh) do
						local player = getVehicleOccupant(veh, i)
						if (player) then
							triggerEvent("resetTintName", veh, player)
						end
					end

					exports['anticheat-system']:changeProtectedElementDataEx(veh, "tinted", false, true)
					outputChatBox("Sikeresen leszedted a rossz szélvédőt.", source)
					exports.global:sendLocalMeAction(source, " Sikeresen leszedte a rossz szélvédőt.")
					exports.logs:dbLog(source, 6, {  veh }, "MODDING REMOVETINT")
					exports.logs:logMessage("[REMOVED TINT-BTR] " .. getPlayerName(source):gsub("_"," ") .. " has removed tint from vehicle #" .. vehID .. " - " .. getVehicleName(veh) .. ".", 9)
				else
					outputChatBox("There was an issues removing the tint. Please report on mantis", source, 255, 0, 0)
				end
			end
		end
	end
end
addEvent("tintedWindows", true)
addEventHandler("tintedWindows", getRootElement(), changeVehicleTint)