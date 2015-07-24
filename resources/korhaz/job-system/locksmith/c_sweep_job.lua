local line, route, m_number, curCpType = nil

local sweepMarker, sweepNextMarker = nil
local sweepBlip, sweepNextBlip = nil
local sweepStopColShape = nil

local sweep = { [574] =true}

local blip

function resetsweepJob()
	if (isElement(blip)) then
		destroyElement(blip)
		removeEventHandler("onClientVehicleEnter", getRootElement(), startsweepJob)
		blip = nil
	end
	
	if isElement(sweepMarker) then
		destroyElement(sweepMarker)
		sweepMarker = nil
	end
	
	if isElement(sweepBlip) then
		destroyElement(sweepBlip)
		sweepBlip = nil
	end
	
	if isElement(sweepNextMarker) then
		destroyElement(sweepNextMarker)
		sweepNextMarker = nil
	end
	
	if isElement(sweepNextBlip) then
		destroyElement(sweepNextBlip)
		sweepNextBlip = nil
	end
	
	m_number = 0
	triggerServerEvent("paysweepDriver", getLocalPlayer(), line, -1)
end

function displaysweepJob()
	blip = createBlip(1480.6318359375, 2372.498046875, 10.8203125, 0, 4, 255, 127, 255)
	outputChatBox("#FF9933Menj az #FF66CCúttisztító telepre#FF9933, hogy elkezd munkát.", 255, 194, 15, true)
	outputChatBox("#FF9933Ha odaértél, szállj be egy úttisztítóba és írd be: '/uttisztitas'.", 255, 194, 15, true)
end

function startsweepJob()
	local job = getElementData(getLocalPlayer(), "job")
	if (job == 7) then
		if blip then
			destroyElement(blip)
			blip = nil
		end
		if sweepMarker then
			outputChatBox("#FF9933You have already started a sweep route.", 255, 194, 14, true)
		else
			local vehicle = getPedOccupiedVehicle(getLocalPlayer())
			if (model==574) then -- SWEEPER
				line = math.random( 1, #g_sweep_routes )
				route = g_sweep_routes[line]
				curCpType = 0
				
				local x, y, z = 1811, -1890, 13 -- Depot start point
				sweepBlip = createBlip(x, y, z, 0, 3, 255, 200, 0, 255)
				sweepMarker = createMarker(x, y, z, "checkpoint", 4, 255, 200, 0, 150) -- start marker.
				sweepStopColShape = createColSphere(0, 0, 0, 5)
				
				addEventHandler("onClientMarkerHit", sweepMarker, updatesweepCheckpointCheck)
				addEventHandler("onClientMarkerLeave", sweepMarker, checkWaitAtStop)
				addEventHandler("onClientColShapeHit", sweepStopColShape,
					function(element)
						if getElementType(element) == "vehicle" and sweep[getElementModel(element)] then
							setVehicleLocked(vehicle, false)
						end
					end
				)
				addEventHandler("onClientColShapeLeave", sweepStopColShape,
					function(element)
						if getElementType(element) == "vehicle" and sweep[getElementModel(element)] then
							setVehicleLocked(vehicle, true)
						end
					end
				)
				
				local nx, ny, nz = route.points[1][1], route.points[1][2], route.points[1][3]
				if (route.points[1][4]==true) then
					sweepNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 0, 0, 150) -- small red marker
					sweepNextBlip = createBlip( nx, ny, nz, 0, 2, 255, 0, 0, 255) -- small red blip
				else
					sweepNextMarker = createMarker( nx, ny, nz, "checkpoint", 2.5, 255, 200, 0, 150) -- small yellow marker
					sweepNextBlip = createBlip( nx, ny, nz, 0, 2, 255, 200, 0, 255) --small  yellow blip
				end
				
				m_number = 0
				triggerServerEvent("paysweepDriver", getLocalPlayer(), line, 0)
				
				setVehicleLocked(vehicle, true)
				
				outputChatBox("#FF9933Drive around the sweep #FFCC00route #FF9933stopping at the #A00101stops #FF9933along the way.", 255, 194, 14, true)
				outputChatBox("#FF9933You will be paid for each stop you make and for people you pick up.", 255, 194, 14, true)
			else
				outputChatBox("#FF9933You must be in a sweep or coach to start the sweep route.", 255, 194, 14, true)
			end
		end
	else
		outputChatBox("Te nem vagy úttisztító jármüben.", 255, 194, 14)
	end
end
addCommandHandler("uttisztitas", startsweepJob, false, false)

function updatesweepCheckpointCheck(thePlayer)
	if thePlayer == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		if vehicle and sweep[getElementModel(vehicle)] then
			if curCpType == 3 then
				sweepStopTimer = setTimer(updatesweepCheckpointAfterStop, 5000, 1, true)
				outputChatBox("#FF9933Wait at the sweep stop for a moment till the marker disappears.", 255, 0, 0, true )
				triggerServerEvent("sweepAdNextStop", getLocalPlayer(), line, route.points[m_number][5])
			elseif curCpType == 2 then
				endOfTheLine()
			elseif curCpType == 1 then
				sweepStopTimer = setTimer(updatesweepCheckpointAfterStop, 5000, 1, false)
				outputChatBox("#FF9933Wait at the sweep stop for a moment till the marker disappears.", 255, 0, 0, true )
				triggerServerEvent("sweepAdNextStop", getLocalPlayer(), line, route.points[m_number][5])
			else
				updatesweepCheckpoint()
			end
		else
			outputChatBox("#FF9933You must be in a sweep or coach to drive the sweep route.", 255, 0, 0, true ) -- Wrong car type.
		end
	end
end

function updatesweepCheckpoint()
	-- Find out which marker is next.
	local max_number = #route.points
	local newnumber = m_number+1
	local nextnumber = m_number+2
	local x, y, z = nil
	local nx, ny, nz = nil
	
	x = route.points[newnumber][1]
	y = route.points[newnumber][2]
	z = route.points[newnumber][3]
	
	if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
		setElementPosition(sweepMarker, x, y, z)
		setElementPosition(sweepBlip, x, y, z)
		
		if (route.points[newnumber][4]==true) then -- If it is a stop.
			curCpType = 3
			setMarkerColor(sweepMarker, 255, 0, 0, 150)
			setBlipColor(sweepBlip, 255, 0, 0, 255)
			setElementPosition(sweepStopColShape, x, y, z)
		else -- it is just a route.
			curCpType = 2
			setMarkerColor(sweepMarker, 255, 200, 0, 150)
			setBlipColor(sweepBlip, 255, 200, 0, 255)
		end
		
		nx, ny, nz = 1811, -1890, 13 -- Depot start point
		setElementPosition(sweepNextMarker, nx, ny, nz)
		setElementPosition(sweepNextBlip, nx, ny, nz)
		setMarkerColor(sweepNextMarker, 255, 0, 0, 150)
		setBlipColor(sweepNextBlip, 255, 0, 0, 255)
		setMarkerIcon(sweepNextMarker, "finish")
	else
		nx = route.points[nextnumber][1]
		ny = route.points[nextnumber][2]
		nz = route.points[nextnumber][3]
		
		setElementPosition(sweepMarker, x, y, z)
		setElementPosition(sweepBlip, x, y, z)
		
		setElementPosition(sweepNextMarker, nx, ny, nz)
		setElementPosition(sweepNextBlip, nx, ny, nz)
		
		if (route.points[newnumber][4]==true) then -- If it is a stop.
			curCpType = 1
			setMarkerColor(sweepMarker, 255, 0, 0, 150)
			setBlipColor(sweepBlip, 255, 0, 0, 255)
			setElementPosition(sweepStopColShape, x, y, z)
		else -- it is just a route.
			curCpType = 0
			setMarkerColor(sweepMarker, 255, 200, 0, 150)
			setBlipColor(sweepBlip, 255, 200, 0, 255)
		end
		
		if (route.points[nextnumber][4] == true) then
			setMarkerColor(sweepNextMarker, 255, 0, 0, 150)
			setBlipColor(sweepNextBlip, 255, 0, 0, 255)
		else
			setMarkerColor(sweepNextMarker, 255, 200, 0, 150)
			setBlipColor(sweepNextBlip, 255, 200, 0, 255)
		end
	end
	m_number = m_number + 1
end

function checkWaitAtStop(thePlayer)
	if thePlayer == getLocalPlayer() then
		if sweepStopTimer then
			outputChatBox("You didn't wait at the sweep stop.", 255, 0, 0)
			if isTimer(sweepStopTimer) then
				killTimer(sweepStopTimer)
				sweepStopTimer = nil
			end
		end
	end
end

function updatesweepCheckpointAfterStop(endOfLine)
	if isTimer(sweepStopTimer) then
		killTimer(sweepStopTimer)
		sweepStopTimer = nil
	end
	local stopNumber = route.points[m_number][5]
	triggerServerEvent("paysweepDriver", getLocalPlayer(), line, stopNumber)
	if endOfLine then
		endOfTheLine(getLocalPlayer())
	else
		updatesweepCheckpoint(getLocalPlayer())
	end
end

function endOfTheLine()
	if sweepNextBlip then
		destroyElement(sweepNextBlip)
		destroyElement(sweepNextMarker)
		sweepNextBlip = nil
		sweepNextMarker = nil
		
		if sweepStopColShape then
			destroyElement(sweepStopColShape)
			sweepStopColShape = nil
		end
		
		local x, y, z = 1811, -1890, 13 -- Depot start point
		setElementPosition(sweepMarker, x, y, z)
		setElementPosition(sweepBlip, x, y, z)
		setMarkerColor(sweepMarker, 255, 0, 0, 150)
		setBlipColor(sweepBlip, 255, 0, 0, 255)
		setMarkerIcon(sweepMarker, "finish")
		curCpType = 2
	else
		if sweepBlip then
			-- Remove the old marker.
			destroyElement(sweepBlip)
			destroyElement(sweepMarker)
			sweepBlip = nil
			sweepMarker = nil
		end
		triggerServerEvent("paysweepDriver", getLocalPlayer(), line, -2)
		setVehicleLocked(vehicle, false)
		outputChatBox("#FF9933End of the Line. Use /startsweep to begin the route again.", 0, 255, 0, true )
	end
end

function entersweep ( thePlayer, seat, jacked )
	if(thePlayer == getLocalPlayer())then
		local vehID = getElementModel (source)
		if(sweep[vehID])then
			if(seat~=0)then
				local driver = getVehicleOccupant(source)
				if driver then -- you can only pay the driver if the sweep has a driver
					if not exports.global:hasMoney(getLocalPlayer(), 5)then
						triggerServerEvent("removePlayerFromsweep", getLocalPlayer())
						outputChatBox("You can't afford the $5 sweep fare.", 255, 0, 0)
					else
						triggerServerEvent("paysweepFare", getLocalPlayer(), driver)
						outputChatBox("You have paid $5 to ride the sweep", 0, 255, 0)
					end
				end
			elseif not sweepMarker and getElementData(getLocalPlayer(), "job") == 3 then
				outputChatBox("#FF9933Use /startsweep to begin the sweep route.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), entersweep)

function startEntersweep(thePlayer, seat)
	if seat == 0 and sweep[getElementModel(source)] then
		if getVehicleController(source) then -- if someone try to jack the driver stop him
			cancelEvent()
			if thePlayer == getLocalPlayer() then
				outputChatBox("The drivers door is locked.", 255, 0, 0)
			end
		else
			setVehicleLocked(source, false)
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), startEntersweep)

function onPlayerQuit()
	if getElementData(source, "job") == 3 then
		vehicle = getPedOccupiedVehicle(source)
		if vehicle and sweep[getElementModel(vehicle)] and getVehicleOccupant(vehicle) == source then
			setVehicleLocked(vehicle, false)
		end
	end
end
addEventHandler("onClientPlayerQuit", getRootElement(), onPlayerQuit)