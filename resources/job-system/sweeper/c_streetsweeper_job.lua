local blip
local jobstate = 0
local route = 0
local marker
local colshape
local routescompleted = 0

routes = { }
routes[1] = { 2042.814453, -1077.234497, 24.224184}
routes[2] = { 2081.817871, -1889.327026, 12.948751 }
routes[3] = { 1961.662109, -2153.399902, 12.958511 }
routes[4] = { 1454.344726, -1393.411010, 12.949224 }
routes[5] = { 1472.282714, -1732.610961, 12.949385 }
routes[6] = { 1077.881713, -1851.862426, 12.957169 }
routes[7] = {  748.104309, -1763.538574, 12.493334 }
routes[8] = { 1216.641723, -1194.164916, 20.116668 }
routes[9] = { 1799.023681, -1731.869873, 12.949433 }
routes[10] = { 1951.156494, -1752.129150, 12.949685 }
routes[11] = { 1821.753784, -1913.239624, 12.954136 }
routes[12] = {2175.790771, -1384.980957, 23.394639 }
routes[13] = { 2303.439208, -1321.457519, 23.402212}
routes[14] = { 2465.900878, -1256.681884, 24.687801 }
routes[15] = {2641.676025, -1280.775390, 46.773239 }


function resetSweeperJob()
	jobstate = 0
	
	if (isElement(marker)) then
		destroyElement(marker)
	end
	
	if (isElement(colshape)) then
		destroyElement(colshape)
	end
	
	if (isElement(blip)) then
		destroyElement(blip)
	end
end

function displaySweeperJob()
	if (jobstate==0) then
		jobstate = 1
		blip = createBlip(1637.0229,-1892.1642,13.5568, 0, 4, 255, 127, 255)
		outputChatBox("#FF9933Menj az #FF66CCúttisztító telepre#FF9933, hogy elkezd munkát.", 255, 194, 15, true)
		outputChatBox("#FF9933Ha odaértél, szállj be egy úttisztítóba és írd be: '/startjob'.", 255, 194, 15, true)
	end
end

function startSweeperJob()
	if (jobstate==1) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		
		if not (vehicle) then
			outputChatBox("Úttisztítóban kell lenned.", 255, 0, 0)
		else
			local model = getElementModel(vehicle)
			if (model==574) then -- SWEEPER
				routescompleted = 0
			
				outputChatBox("#FF9933Menj a #FF66CCcheckpointba#FF9933 és írd be: '/cleanroad'.", 255, 194, 15, true)
				destroyElement(blip)
				
				local rand = math.random(1, 15)
				route = routes[rand]
				local x, y, z = routes[rand][1], routes[rand][2], routes[rand][3]
				blip = createBlip(x, y, z, 0, 4, 255, 127, 255)
				marker = createMarker(x, y, z, "cylinder", 4, 255, 127, 255, 150)
				colshape = createColCircle(x, y, z, 4)
								
				jobstate = 2
			else
				outputChatBox("Nem vagy úttisztító.", 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startjob", startSweeperJob)

function cleanRoad()
	if (jobstate==1 or jobstate==2) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		
		if not (vehicle) then
			outputChatBox("Te nem vagy úttisztító jármüben.", 255, 0, 0)
		else
			local model = getElementModel(vehicle)
			if (model==574) then -- MULE
				if (isElementWithinColShape(vehicle, colshape)) then
					destroyElement(colshape)
					destroyElement(marker)
					destroyElement(blip)
					outputChatBox("Ha befejezted az úttiszttást menj a telephelyre.", 0, 255, 0)
					routescompleted = routescompleted + 1
					outputChatBox("#FF9933Most már visszatérhetsz a #00CC00Telephelyre #FF9933Vedd fel a fizetést", 0, 0, 0, true)
					outputChatBox("#FF9933Vagy folytatod  #FF66CCdolgozol#FF9933 és növeled a fizetét.", 0, 0, 0, true)
					
					-- next drop off
					local rand = math.random(1, 10)
					route = routes[rand]
					local x, y, z = routes[rand][1], routes[rand][2], routes[rand][3]
					blip = createBlip(x, y, z, 0, 4, 255, 127, 255)
					marker = createMarker(x, y, z, "cylinder", 4, 255, 127, 255, 150)
					colshape = createColCircle(x, y, z, 4)
					
					if not(endblip)then
						-- end marker
						endblip = createBlip(2836, 975, 9.75, 0, 4, 0, 255, 0)
						endmarker = createMarker(2836, 975, 9.75, "cylinder", 4, 0, 255, 0, 150)
						endcolshape = createColCircle(2836, 975, 9.75, 4)
						addEventHandler("onClientColShapeHit", endcolshape, endTruckJob, false)
					end
					jobstate = 1
				else
					outputChatBox("#FF0066Nem vagy a telephelyen #FF66CCMenj oda#FF0066.", 255, 0, 0, true)
				end
			else
				outputChatBox("Te nem vagy úttisztító jármüben..", 255, 0, 0)
			end
		end
	end
end
addCommandHandler("dumpload", dumpTruckLoad)

function endTruckJob()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not (vehicle) then
		outputChatBox("Te nem vagy úttisztító jármüben.", 255, 0, 0)
	else
		local model = getElementModel(vehicle)
		if (model==574) then -- MULE
			if (jobstate==3) then

				local wage = 50*routescompleted
				outputChatBox("Te kerestél " .. wage .. " Az úttiszttásért .", 255, 194, 15)
				local vehicle = getPedOccupiedVehicle(localPlayer)
				triggerServerEvent("giveTruckingMoney", localPlayer, wage)

			end
			
			triggerServerEvent("respawnTruck", localPlayer, vehicle)
			outputChatBox("Köszönjük szolgáltatások RS Haul.", 0, 255, 0)
			destroyElement(colshape)
			destroyElement(marker)
			destroyElement(blip)
			destroyElement(endblip)
			destroyElement(endmarker)
			destroyElement(endcolshape)
			routescompleted = 0

			triggerServerEvent("quitjob", localPlayer)
		else
			outputChatBox("Nem vagy úttisztittó.", 255, 0, 0)
		end
	end
end
