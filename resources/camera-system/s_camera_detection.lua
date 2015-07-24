function monitorSpeed(theVehicle, matchingDimension)
	if (matchingDimension) and (getElementType(theVehicle)=="vehicle") then
		local enabled = getElementData(source, "speedcam:enabled")
		if (enabled) then
			local thePlayer = getVehicleOccupant(theVehicle)
			if thePlayer then
				local maxSpeed = getElementData(source, "speedcam:maxspeed")
				local timer = setTimer(checkSpeed, 100, 30, theVehicle, thePlayer, source, maxSpeed)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:timer", timer, false)
			end
		end
	end
end

function stopMonitorSpeed(theVehicle, matchingDimension)
	if (matchingDimension) and (getElementType(theVehicle)=="vehicle") then
		local thePlayer = getVehicleOccupant(theVehicle)
		if thePlayer then
			local timer = getElementData(thePlayer, "speedcam:timer")
			if isTimer( timer ) then
				killTimer( timer )
			end
			exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "speedcam:timer",false, false)
		end
	end
end

function checkSpeed(theVehicle, thePlayer, colshape, maxSpeed)
	local currentSpeed = math.floor(exports.global:getVehicleVelocity(theVehicle))
	
	if (currentSpeed > maxSpeed) then
		local timer = getElementData(thePlayer, "speedcam:timer")
		if timer then
			killTimer(timer)
		end
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:timer",false, false)

		-- Flash!
		for i = 0, getVehicleMaxPassengers(theVehicle) do
			local p = getVehicleOccupant(theVehicle, i)
			if p then
				triggerClientEvent(p, "speedcam:cameraEffect", p)
			end
		end
		local x, y, z = getElementPosition(thePlayer)
		setTimer(sendWarningToCops, 500, 1, theVehicle, thePlayer, currentSpeed, x, y, z)
	end
end


--Color Names
local colors = {
	"fehér", "kék", "piros", "sötétzöld", "lila",
	"sárga", "kék", "szürke", "kék", "ezüst",
	"szürke", "kék", "sötétszürke", "ezüst", "szürke",
	"zöld", "piros", "piros", "szürke", "kék",
	"piros", "piros", "szürke", "sötétszürke", "sötétszürke",
	"ezüst", "barna", "kék", "ezüst", "barna",
	"piros", "kék", "szürke", "szürke", "sötétszürke",
	"black", "zöld", "világoszöld", "kék", "black",
	"barna", "piros", "piros", "zöld", "piros",
	"bézs", "barna", "szürke", "ezüst", "szürke",
	"zöld", "kék", "sötétkék", "sötétkék", "barna",
	"ezüst", "bézs", "piros", "kék", "szürke",
	"barna", "piros", "ezüst", "ezüst", "zöld",
	"sötétpiros", "kék", "bézs", "rózsaszín", "piros",
	"kék", "barna", "világoszöld", "piros", "black",
	"ezüst", "bézs", "piros", "kék", "sötétpiros",
	"lila", "sötétpiros", "sötétkék", "sötétbarna", "lila",
	"zöld", "kék", "piros", "bézs", "ezüst",
	"sötétkék", "szürke", "kék", "kék", "kék",
	"ezüst", "világoskék", "szürke", "bézs", "kék",
	"black", "bézs", "kék", "bézs", "szürke",
	"kék", "bézs", "kék", "sötétszörke", "barna",
	"ezüst", "kék", "sötétbarna", "sötétzöld", "piros",
	"sötétkék", "piros", "ezüst", "sötétbarna", "barna",
	"piros", "szürke", "barna", "piros", "kék",
	"pink", [0] = "fekete" }

local function vehicleColor( c1, c2 )
	local color1 = colors[ c1 ] or "Ismeretlen szín"
	local color2 = colors[ c2 ] or "Ismeretlen szín"
	
	if color1 ~= color2 then
		return color1 .. " & " .. color2
	else
		return color1
	end
end

function sendWarningToCops(theVehicle, thePlayer, speed, x, y, z)
	local direction = "Ismeretlen"
	local areaName = getZoneName(x, y, z)
	local nx, ny, nz = getElementPosition(thePlayer)
	local vehicleName = getVehicleName(theVehicle)
	local vehicleID = getElementData(theVehicle, "dbid")
	local color1, color2 = getVehicleColor(theVehicle)
	
	local dx = nx - x
	local dy = ny - y
	
	if dy > math.abs(dx) then
		direction = "északi"
	elseif dy < -math.abs(dx) then
		direction = "déli"
	elseif dx > math.abs(dy) then
		direction = "keleti"
	elseif dx < -math.abs(dy) then
		direction = "nyugati"
	end
	
	if not (vehicleName == "Police LS") and not (vehicleName == "Police LV") and not (vehicleName == "Police SF") and not (vehicleName == "Police Ranger")  then
		local teamPlayers = { }
		local LSPDmembers = getTeamFromName("Rendőrség")
		for a, b in ipairs(getPlayersInTeam(LSPDmembers)) do
			for _, itemRow in ipairs(exports['item-system']:getItems(b)) do 
				local setIn = false
				if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
					table.insert(teamPlayers, b)
					setIn = true
					break
				end
			end
		end
		
		local SPDmembers = getTeamFromName("SCPD")
		for a, b in ipairs(getPlayersInTeam(SPDmembers)) do
			for _, itemRow in ipairs(exports['item-system']:getItems(b)) do 
				local setIn = false
				if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
					table.insert(teamPlayers, b)
					setIn = true
					break
				end
			end
		end

		for key, value in ipairs(teamPlayers) do
			--local duty = tonumber(getElementData(value, "duty"))
			--if (duty>0) then
			outputChatBox("[RADIO] Minden egység gyorshajtás " .. areaName .. " úton.", value, 0, 100, 255)
			outputChatBox("[RADIO] A jármű szine: " .. vehicleColor(color1, color2) .. " Típusa: " .. vehicleName .. " Sebessége: " .. tostring(math.ceil(speed)) .. " KM/h.", value, 0, 100, 255)
			if exports['vehicle-system']:hasVehiclePlates( theVehicle ) then
				outputChatBox("[RADIO] A rendszáma '"..  getVehiclePlateText ( theVehicle ) .."' és " .. direction .. " irányba tart.", value, 0, 100, 255)
			else
				outputChatBox("[RADIO] A járműnek nincsen rendszáma és " .. direction .. " irányba tart.", value, 0, 100, 255)
			end
			--end
		end
		
		if vehicleID > 0 then
			local playerseen = -1
			if not getElementData(theVehicle, "tinted") or getElementData(theVehicle, "vehicle:windowstat") ~= 0 then
				playerseen = getElementData(thePlayer, "dbid") or -1
			end
			exports['mysql']:query_free("INSERT INTO `speedingviolations` (`carID`, `time`, `speed`, `area`, `personVisible`) VALUES ('".. exports['mysql']:escape_string(vehicleID).."', NOW(), '".. exports['mysql']:escape_string(tostring(math.ceil(speed))).."', '".. exports['mysql']:escape_string(areaName .. " " ..direction).."', '".. exports['mysql']:escape_string(playerseen).."')")
		end
	end
end