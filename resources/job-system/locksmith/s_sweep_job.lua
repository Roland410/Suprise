local drivers = {}
local blips = {}
local acCheck = { }

function updatesweepBlips(line)
	local driversonline = 0
	for k, v in ipairs(drivers[line]) do
		driversonline = driversonline + #v
	end
	
	if driversonline > 0 then
		for k, v in ipairs(drivers[line]) do
			if #(drivers[line][k-1] or {}) + #v > 0 then
				setBlipColor( blips[line][k], 127, 255, 63, 127 )
			else
				setBlipColor( blips[line][k], 255, 255, 63, 127 )
			end
		end
	else
		for k, v in ipairs(blips[line]) do
			setBlipColor( v, 255, 63, 63, 127 )
		end
	end
end

function removeDriver()
	for k, v in ipairs(drivers) do
		for key, value in ipairs(v) do
			for i, player in pairs(value) do
				if player == source then
					table.remove(value, i)
				end
			end
		end
	end
end

function removeDriverOnAllLines()
	removeDriver()
	for line, v in pairs(drivers) do
		updatesweepBlips(line)
	end
end
addEventHandler( "onPlayerQuit", getRootElement(), removeDriverOnAllLines )
addEventHandler("onCharacterLogin", getRootElement(), removeDriverOnAllLines )

function paysweepDriver(line, stop)
	local seat = getPedOccupiedVehicleSeat(client)
	if not seat or seat ~= 0 then
		return
	end
	
	if (acCheck[client] == stop) and (stop ~= -1) then
		triggersweepCheatDetection(client,stop)
	end
	acCheck[client] = stop

	if stop == -2 then
		removeDriver()
		exports.global:giveMoney(client, 36)
	elseif stop == -1 then
		removeDriverOnAllLines()
		return
	elseif stop == 0 then
		table.insert( drivers[line][1], client )
	else
		exports.global:giveMoney(client, 18)

		if drivers[line][stop+1] then
			removeDriver()
			table.insert( drivers[line][stop+1], client )
		end
	end
	updatesweepBlips(line)
end
addEvent("paysweepDriver",true)
addEventHandler("paysweepDriver", getRootElement(), paysweepDriver)

function triggersweepCheatDetection(thePlayer,stop)
	exports.logs:logMessage("[paysweepDriver]".. getPlayerName(thePlayer) .. " " .. getPlayerIP(thePlayer) .. " used the same stop twice ("..stop..")" , 32)
end

function sweepAdNextStop(line, stop)
	local seat = getPedOccupiedVehicleSeat(source)
	if not seat or seat ~= 0 then
		return
	end
	
	exports.global:sendLocalText(source, " -- This stop: [".. g_sweep_routes[line].stops[stop] .. "] --", 255, 51, 102)
	if(stop<#g_sweep_routes[line].stops)then
		exports.global:sendLocalText(source, " -- Next stop: [".. g_sweep_routes[line].stops[stop+1] .. "] --", 255, 51, 102)
	end
end
addEvent("sweepAdNextStop",true)
addEventHandler("sweepAdNextStop", getRootElement(), sweepAdNextStop)

function takesweepFare(thePlayer)
	exports.global:takeMoney(source, 5)
	exports.global:giveMoney(thePlayer, 5)
end
addEvent("paysweepFare", true)
addEventHandler("paysweepFare", getRootElement(), takesweepFare)

function ejectPlayerFromsweep()
	exports['anticheat-system']:changeProtectedElementDataEx(source, "realinvehicle", 0, false)
	removePedFromVehicle(source)
end
addEvent("removePlayerFromsweep", true)
addEventHandler("removePlayerFromsweep", getRootElement(), ejectPlayerFromsweep)

-- sweep ROUTES BLIPS
function createsweepBlips( )
	for routeID, route in ipairs( g_sweep_routes ) do
		blips[routeID] = {}
		drivers[routeID] = {}
		for pointID, point in ipairs( route.points ) do
			if point[4] and #route.points ~= pointID then
				local stop = #blips[routeID]+1
				blips[routeID][stop] = createBlip( point[1], point[2], point[3], 0, 1, 255, 63, 63, 127, -5, 65 )
				drivers[routeID][stop] = {}
			end
		end
	end
end
addEventHandler( "onResourceStart", getResourceRootElement(), createsweepBlips )