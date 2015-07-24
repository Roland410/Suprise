local mysql = exports.mysql
local serverRegFee = 5500

function getPlateList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports.pool:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports['vehicle-system']:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:clist", client, vehicleTable)
end
addEvent("vehicle-plate-system:list", true)
addEventHandler("vehicle-plate-system:list", getRootElement(), getPlateList)

function pedTalk(state)
	if (state == 1) then
		exports.global:sendLocalText(source, "Gabrielle McCoy mondja: Üdvözlöm! Szeretne beregisztrálni egy új rendszámot?", nil, nil, nil, 10)
		outputChatBox("A regisztrációs ár ".. exports.global:formatMoney(serverRegFee) .. " forint járművenként.", source)
	elseif (state == 2) then
		exports.global:sendLocalText(source, "Gabrielle McCoy mondja: Sajnálom de a regisztrációs díj " .. exports.global:formatMoney(serverRegFee) .. ". Kérem jöjjön vissza később ennyi pénzzel.", nil, nil, nil, 10)
	elseif (state == 3) then
		exports.global:sendLocalText(source, "Gabrielle McCoy mondja: Rendben van! Kérem adja meg a járművének adatait.", nil, nil, nil, 10)
	elseif (state == 4) then
		exports.global:sendLocalText(source, "Gabrielle McCoy mondja: Nem? Nos, bizakodom hogy később megváltoztatja a döntését. További szép napot!", nil, nil, nil, 10)
	elseif (state == 5) then
		exports.global:sendLocalText(source, " *Gabrielle McCoy közelebb hajol a számítógéphez majd a két kezét ráhelyezi a billentyűzetre és elkezd gépelni.", 255, 51, 102)
		exports.global:sendLocalText(source, "Gabrielle McCoy mondja: Rendben, az adatait felvittem, járműve be van regisztrálva. További szép napot!", nil, nil, nil, 10)
	elseif (state == 6) then
		exports.global:sendLocalText(source, "Gabrielle McCoy says: Hmmm. A nyilvántartásunkban, már be van regisztrálva a rendszám.", nil, nil, nil, 10)
	end
end
addEvent("platePedTalk", true)
addEventHandler("platePedTalk", getRootElement(), pedTalk)

function setNewInfo(data, car)
	if (data) and (car) then
		local cquery = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. mysql:escape_string(data).."'")
		if (tonumber(cquery["no"]) > 0) then
			triggerEvent("platePedTalk", source, 6)
		else
			local townerid = getElementData(source, "dbid")
			local tvehicle = exports.pool:getElement("vehicle", car)
			local owner = getElementData(tvehicle, "owner")
			if (townerid==owner) then
				if (checkPlate(data)) and exports['vehicle-system']:hasVehiclePlates(tvehicle) then
					local insertnplate = mysql:query_free("UPDATE vehicles SET plate='" .. mysql:escape_string(data) .. "' WHERE id = '" .. mysql:escape_string(car) .. "'")
					if (insertnplate) then
						if (exports.global:takeMoney(source, serverRegFee)) then
							local x, y, z = getElementPosition(tvehicle)
							local int = getElementInterior(tvehicle)
							local dim = getElementDimension(tvehicle)
							exports['vehicle-system']:reloadVehicle(tonumber(car))
							local tnvehicle = exports.pool:getElement("vehicle", car)
							setElementPosition(tnvehicle, x, y, z)
							setElementInterior(tnvehicle, int)
							setElementDimension(tnvehicle, dim)
							triggerEvent("platePedTalk", source, 5)
						else
							triggerEvent("platePedTalk", source, 2)
						end
					else
						outputChatBox("((HIBA VPS0-001 keress fel egy scriptert.))", source, 255,0,0)
					end
				else
					outputChatBox("((HIBA VPS0-003 keress fel egy scriptert.))", source, 255,0,0)
				end
			end
		end
	else
		outputChatBox("((HIBA VPS0-002 keress fel egy scriptert.))", source, 255,0,0)
	end
end
addEvent("sNewPlates", true)
addEventHandler("sNewPlates", getRootElement(), setNewInfo)
